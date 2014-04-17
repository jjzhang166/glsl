#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159265359

//
// Description : Array and textureless GLSL 2D/3D/4D 
//               noise functions.
//      Author : People
//  Maintainer : Anyone
//     Lastmod : 20120109 (Trisomie21)
//     License : No Copyright No rights reserved.
//               Freely distributed
//
float snoise(vec3 uv)
{
	const vec3 s = vec3(1e0, 1e2, 1e4);
	vec3 f = fract(uv);
	f = f*f*(3.0-2.0*f);
	uv = floor(uv);
	vec4 v = vec4(dot(uv, s)) + vec4(0., s.x, s.y, s.x+s.y);
	vec4 r = fract(sin(v*1e-3)*1e5);
	float r0 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);
	r = fract(sin((v+s.z)*1e-3)*1e5);
	float r1 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);
	return mix(r0, r1, f.z)*2.-1.;
}

//rob dot dunn at gmail 
//Inspired by Ken Perlin's slides: http://www.noisemachine.com/talk1/24a.html
void main( void ) {
	vec3 var = vec3(1);
	
	vec3 g = var;
	
	g = var * var;
	g = g * g * (3.0-2.0*g);
	
	g = .5 * g;
	
	g = .5 * vec3(0.5);
	
	vec2 a;
	
	g =  g / .5;
	
	mat2 b;
	
	b = 2.0 * b;
	
	
	
}