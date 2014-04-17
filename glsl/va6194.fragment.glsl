#ifdef GL_ES
precision mediump float;
#endif

// T21 : Rubics cube attempt #1

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec3 n, float res){
	n = floor(n*res);
	return fract(sin((n.x+n.y*1e2+n.z*1e4)*1e-2)*1e5);
}

vec3 GetCoord(vec3 p) {
	float a = time*(rand(p*vec3(7.,1.,1.), 1.)*2.-1.);
	vec3 pos;
	p = fract(p)-.5;
	pos.y = p.y*cos(a) - p.z*sin(a);
	pos.z = p.z*cos(a) + p.y*sin(a);
	pos.x = p.x;
	return pos;
}

float distance(vec3 p) {
	return length(max(max(abs(GetCoord(p))-.2,0.), abs(p)-2.75));
}

float color(vec3 n, float res){
	return rand(n, res);
}

void main( void ) {
	vec3 lookAt = vec3(0);
	vec3 dir = normalize(vec3(mouse.x-.5,mouse.y-.5,1.));
	vec3 left = normalize(cross(dir,vec3(0,1,0)));
	vec3 up = cross(dir,left);
	
	vec3 pos = -dir*10.;
	
	vec2 screen = (gl_FragCoord.xy-resolution*.5)/resolution.x;
	
	vec3 ray = normalize(dir+left*screen.x+up*screen.y);
	
	float dsum = 0.;
	float d;
	float s = 0.;
	for (int i = 0; i < 100; i++) {
		d = distance(pos);
		dsum += d;
		pos += d*ray;
		s += 1.;
		if(d<.001) break;
	}
	
	float c = color(GetCoord(pos)+vec3(.25,0.25,0.25)+floor(pos), 6.);
	gl_FragColor = vec4(1.-(s/30.))*.5 + vec4(vec3(fract(c*16.),fract(c*32.),fract(c*64.))*(3.-pos.z)*.1,1.);
}