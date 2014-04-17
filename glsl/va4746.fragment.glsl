//Michael Huang (please excuse the fake sphere mapping and sloppy code)

// some mods by @rotwang

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;
#define PI 3.1416
const vec3 SEA = vec3(0.0, 0.15, 0.4);
const vec3 SAND = vec3(0.6, 0.7, 0.55);
const vec3 GRASS = vec3(0.2, 0.7, 0.3);
const vec3 ICE = vec3(0.8, 0.9, 0.9);
const vec3 NIGHTLIGHTS = vec3(0.4, 0.35, 0.2);
vec3 st(vec2 sc, float sh, float rim);
float perlin(vec2 p);
vec2 noise(vec2 n);


void main( void ) {

	vec2 p = (-1.0 + 2.0 * ((gl_FragCoord.xy) / resolution.xy));
	p.x *= (resolution.x / resolution.y);
	p = surfacePosition*2.0;
	vec3 c = vec3(0);
	float dist = dot(p, p);
	const float br = 0.6;
	//if(dist < br*br){
		vec2 ssc = p/br;
		float sx = tan(ssc.x*0.346*PI)*0.6;
		float widthFromY = sqrt(1.5 - ssc.y*ssc.y);
		float nsx = sx/widthFromY;
		vec2 sc = vec2(nsx+time*0.125, p.y/br/widthFromY);
		c = st(sc, nsx, dist/(br*br));
	//}
	float m = length(p*1.433);
	float md =1.0-length(p*0.5);
	m = smoothstep(0.85,0.9, m);
	c = mix(c,vec3(0.0,0.0,0.2*md*md),m);
	
	c += md*0.5*vec3(0.9,0.8,0.9)*1.5;
	
	vec2 q = p;
	q.x-= 0.5;
	q.y-= 0.25;
	c+= (1.0-length(q*4.0))*vec3(0.99,0.8,0.30);
	gl_FragColor = vec4(c, 1.0);
}

vec3 st(vec2 sc, float sh, float rim){
	//return vec3(mod(sc, vec2(0.1))*10., 1.);
	float x = perlin(sc*1.5)*70. + perlin(sc*7.)*20. + perlin(sc*20.)*10. + perlin(sc*60.)*7.;
	float stdsh =  -sh*0.3+0.5;
	if(x > 30. - abs(sc.y)*20.){
		return ICE * vec3(stdsh*1.15 + 0.0, stdsh + 0.1, stdsh + 0.1) + vec3(gl_FragCoord.xy / resolution.xy, 1.0)*pow(rim, 10.);
	}else if(x > 3.){
		return GRASS * (x * 0.007 + 0.7) * vec3(stdsh*3.0-0.9, stdsh*0.8+0.2, stdsh*0.8+0.2) + (NIGHTLIGHTS*max(0.,sh)*max(0.,perlin(sc*80.0))*0.9*max(0.,-x*0.3+4.)) + vec3(gl_FragCoord.xy / resolution.xy, 1.0)*pow(rim, 10.);
	}else if(x > 1.){
		return SAND * stdsh + vec3(gl_FragCoord.xy / resolution.xy, 1.0)*pow(rim, 10.);
	}else{
		//return SEA * vec3(stdsh, stdsh*0.8+0.2, stdsh*0.8+0.2) + max(0.,sh-1.5) * GLOW;
		return SEA * vec3(stdsh, stdsh*0.8+0.2, stdsh*0.8+0.2) + vec3(gl_FragCoord.xy / resolution.xy, 1.0)*pow(rim, 5.);
	}
}

//stolen from http://glsl.heroku.com/e#4698.0
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