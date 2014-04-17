#ifdef GL_ES
precision mediump float;
#endif


const int iterations = 50;

const vec3 day = vec3(0.3, 0.4, 0.8);
const vec3 night = vec3(0.05);
const vec2 sun = vec2(0.35,0.05);
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 noise(vec2);
float perlin(vec2);
float fbm(vec2);
float pattern( in vec2 );

vec2 m = mouse - 0.01;
float aspect = resolution.x / resolution.y;


vec3 getColor(vec2 pos) {
	if (distance(pos, m) < 0.1100) {
		return vec3(0.0);
	}
	if (length(pos-sun) < 0.1) {
		return vec3(1.0, 1.0, 0.8);	
	}
	
	float lm = length(m-sun);
	if (lm < 0.2) {
		return mix(night, day, lm / 0.2);	
	}
	return day;
	
}



void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - 0.5;
	position.x *= aspect;
	m.x *= aspect;

	vec3 color = getColor(position);		
		
	vec3 light;
	vec2 incr = (position-sun) / float(iterations);
	vec2 p = sun + incr;
	for (int i = 1; i < iterations; i++) {
		light += getColor(p);
		p += incr;
	}
	
	light /= float(iterations) * max(.01, dot(position-sun, position-sun)) * 50.0;
	
	if (distance(position, m) < 0.11) {
		color = vec3(0.0);
	}
	
	//FOG
	vec2 point=(gl_FragCoord.xy/resolution.y)*10.0;
	point.x-=resolution.x/resolution.y*5.0;point.y-=5.0;
	
	float fx=(fbm(point)+0.5)/4.0;
	vec3 fog =vec3(fx,fx,fx);
		
	gl_FragColor = vec4(color + light+fog*0.2, 1.0);

}


float fbm(vec2 p) {
	float tme=time*0.1;
	float f=0.0;
	f+=perlin(p+tme);
	f+=perlin(vec2(p.x+tme*0.5,p.y)*2.0)*0.5;
	f+=perlin(vec2(p.x,p.y-tme*0.25)*4.0)*0.25;
	f+=perlin((p-tme*0.125)*8.0)*0.125;
	f+=perlin((p+tme*0.0625)*16.0)*0.0625;
	return f/1.0;
}

float perlin(vec2 p) {
	vec2 q=floor(p);
	vec2 r=fract(p);
	float s=dot(noise(q),p-q);
	float t=dot(noise(vec2(q.x+1.0,q.y)),p-vec2(q.x+1.0,q.y));
	float u=dot(noise(vec2(q.x,q.y+1.0)),p-vec2(q.x,q.y+1.0));
	float v=dot(noise(vec2(q.x+1.0,q.y+1.0)),p-vec2(q.x+1.0,q.y+1.0));
	float Sx=3.0*(r.x*r.x)-2.0*(r.x*r.x*r.x);
	float a=s+Sx*(t-s);
	float b=u+Sx*(v-u);
	float Sy=3.0*(r.y*r.y)-2.0*(r.y*r.y*r.y);
	return a+Sy*(b-a);
}

vec2 noise(vec2 n) {
	vec2 ret;
	ret.x=fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453)*2.0-1.0;
	ret.y=fract(sin(dot(n.xy, vec2(34.9865, 65.946)))* 28618.3756)*2.0-1.0;
	return normalize(ret);
}