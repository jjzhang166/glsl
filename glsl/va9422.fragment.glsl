#ifdef GL_ES
precision mediump float;
#endif

//work very much in progress - too much coffee, not enough sleep, thus...

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform sampler2D backbuffer;
varying vec2 surfacePosition;

float sdf(vec2 p, vec2 uv){
	return length(uv-p);
}

float lsdf(vec2 a, vec2 b, vec2 uv){
	float d0,d1,l;
	
	vec2  d = normalize(b.xy - a.xy);
	
	l  = distance(a.xy, b.xy);
	d0 = max(abs(dot(uv - a.xy, d.yx * vec2(-1.0, 1.0))), 0.0),
	d1 = max(abs(dot(uv - a.xy, d) - l * 0.5) - l * 0.5, 0.0);
	
	return length(vec2(d0, d1));
}

float circle(vec2 p, vec2 uv, float r){
	return step(sdf(p,uv), r);
}

float line(vec2 a, vec2 b, vec2 uv, float w){
	float l = lsdf(a,b,uv);
	return step(l,w);
}

float gravity(float a, vec2 uv){
	return lsdf(vec2(0.,1.), vec2(1.,1.), uv);
}

vec4 write(vec4 v, vec2 a){
	vec2 mem = floor(gl_FragCoord.xy);
	vec2 add = floor(a);
	
	if (mem.x == add.x && mem.y == add.y){
		return v;
	}

	return vec4(0.);
}

vec4 read(vec2 a){
	vec2 add = floor(a);
	
	return texture2D(backbuffer, add);
}

vec4 physics(vec2 m, vec2 uv){
	//Sdf Test
	float lw = 0.002;
	float cw = 0.01;
	
	vec4 p0 = vec4(.5, .5, .0, .001);
	vec4 p1 = vec4(m, .01, .01);
	
	float lf = lsdf(p0.xy, p1.xy, uv);
	
	float l0 = line(p0.xy, p1.xy, uv, lw);
	float c0 = circle(p0.xy, uv, cw);
	float c1 = circle(p1.xy, uv, cw);
	
	vec2 xy = p0.xy * c0 + p1.xy * c1;
	vec2 zw = p0.zw;// + p1.zw;
	
	return  vec4(l0+c0+c1+lf);
}

vec4 particles(vec2 m, vec2 uv){
	
	float ani = mod(time,gl_FragCoord.x);
	
	vec4 w = vec4(0.);
	float p = 0.;
	
	const float count = 60.;

	for(float i = 1.; i < count; i++){
		
		vec2 ra = vec2(i, 0.);
		vec4 v = read(ra);
		
		vec2 puv = vec2(count*(i/gl_FragCoord.x)-uv.x, uv.y);

		p += circle(v.xy*v.zw, puv, 0.01);
	}
	
	if(gl_FragCoord.y >= 0. ){
		float vx =  1.;//mix(0., 1., abs(sin((time+gl_FragCoord.x))));
		float vy =  mix(0., 1., abs(sin(.21*(time+gl_FragCoord.x))));
		float vz =  uv.x;
		float vw =  mix(0., 1., (sin(1.21*(time+gl_FragCoord.x))));
		
		//todo: write actual particle data
		//write to top read from bottom?
		vec4 v = vec4(vx, vy, vz, vw);
		
		v = min(vec4(1.), max(vec4(0.), v));
		
		vec2 wa = vec2(gl_FragCoord.x, 0.);
		
		w = write(v,wa);
	}
	
	return vec4(p)+w;
}

void main( void ) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec2 m = mouse;
	

	vec4 phys = physics(mouse, uv);
	vec4 part = particles(m, uv);
	
	
	gl_FragColor = phys + part;
}//acs