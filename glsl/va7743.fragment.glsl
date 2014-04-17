#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Created by inigo quilez - iq/2013
// forked by Florian Hoenig 3/2013
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

mat3 m = mat3( 0.00,  0.80,  0.60,
              -0.80,  0.36, -0.48,
              -0.60, -0.48,  0.64 );

float hash( float n ) {
	    return fract(sin(n)*12758.5453);
}

float noise( in vec3 x ) {
	vec3 p = floor(x);
	vec3 f = fract(x);
	
	f = f*f*(3.0-2.0*f);
	
	float n = p.x + p.y*57.0 + 113.0*p.z;
	
	float res = mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
			mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),
		    mix(mix( hash(n+113.0), hash(n+114.0),f.x),
			mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
	return res;
}

float fbm( vec3 p ) {
	float f = 0.0;
	
	f += 0.5000*noise( p ); p = m*p*2.02;
	f += 0.2500*noise( p ); p = m*p*2.03;
	f += 0.1250*noise( p ); p = m*p*2.01;
	f += 0.0625*noise( p );
	
	return f/0.9375;
}



void main(void)
{
	vec2 q = gl_FragCoord.xy / resolution.xy;
	vec2 p = -1.0 + 2.0 * q;
	p.x *= resolution.x / resolution.y;
	float n = fbm(vec3(p*10.0, time));
	gl_FragColor = vec4(n, n, n, 1.0);
}