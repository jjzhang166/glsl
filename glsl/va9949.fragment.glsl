#ifdef GL_ES
precision highp float;
#endif

//thanks to http://glsl.heroku.com/e#9921.1 && http://glsl.heroku.com/e#9103.4

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 4./atan(1.)

vec4 xyzw(in float v) {
	const float K = 1.0/6.0;

	float w = -1.+2.*v;
	
	v = 2.*PI*sin(v);
	v = v - floor(v);
	
	vec3 t = vec3( 
		(sin(w-(3.0*PI/2.0))+1.0)/2.0,
		(sin(w)+1.0)/2.0,
		(sin(w+(3.0*PI/2.0))+1.0)/2.0
		);
	
	//using as ghetto basis
	float x = w + smoothstep( 2.0*K, 1.3*K, v) + smoothstep( 4.0*K, 5.0*K, v);
	float y = w + smoothstep( 0.0*K, 1.0*K, v) - smoothstep( 3.0*K, 4.0*K, v);
	float z = w + smoothstep( 2.0*K, 3.0*K, v) - smoothstep( 5.0*K, 6.0*K, v);
	
	w = sin(8.*256.*PI*v);
	
	return vec4(x,y,z,w);
}

void main( void ) {

	vec2 uv = gl_FragCoord.xy / resolution.xy;
	
	float v = mouse.x;
	
	gl_FragColor = xyzw(v);
}
//experiment - slowly moving towards something useful - not intended to replace packing bits
//sphinx