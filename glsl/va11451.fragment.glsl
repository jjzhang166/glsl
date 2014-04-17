#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Noise functions from IQ
float hash (float n) {
	return fract(sin(n) * 43758.5453123);	
}

// 3d noise
float noise( vec3 v ) {
	vec3 p = floor(v);
	vec3 f = fract(p);
	f = f*f*(3.0-2.0*f);
	float n = p.x + 57.0*p.y + 113.0*p.z + time * 0.0001;
	float res = mix(mix(mix( hash(n+  0.0), hash(n+  1.0), f.x),
			    mix( hash(n+ 57.0), hash(n+ 58.0), f.x), f.y),
			mix(mix( hash(n+113.0), hash(n+114.0), f.x), 
			    mix( hash(n+170.0), hash(n+171.0), f.x), f.y), f.z);
	return res;		
}

// 2d noise
float noise( vec2 v ) {
	vec2 p = floor(v);
	vec2 f = fract(v);
	float n = p.x + 57.0*p.y;
	float res = mix(mix( hash(n+ 0.0), hash(n+ 1.0), f.x),
			mix( hash(n+57.0), hash(n+58.0), f.x), f.y);
	return res;
}

float squares( vec2 p, int o) {
	float n = 0.0;
	float w = 1.0;
	for (int i=0; i<32; i++) {
		if (i<o) {
			w /= 2.0;
			n += w * noise(vec3(p, 0.0));
			p *= 2.; // two squares per axis on each subdivision
		}
		else break;
	}
	return (n / (1.0 - w));
}

mat3 m3 = mat3( 0.00,  0.80,  0.60,
	       -0.80,  0.36, -0.48,
	       -0.60, -0.48,  0.64);

float fbm ( vec3 p, int o ) {
	float n = 0.0;
	float w = 1.0;
	for (int i=0; i<32; i++) {
		if (i<o) {
			w = 1.0 / float(o);
			n += w * noise(p);
			p *= m3 * 2.02;  
		}
		else break;
	}
	return (n / (1.0 - w));
}

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy - 0.5;
	position.x *= resolution.x / resolution.y;
	
	float n;
	n = smoothstep(0.4, 1.0, squares(position * 16.01, 4));
	
	//n = fbm(vec3(position, sqrt(position.x * position.x + position.y * position.y - 0.125)) * 1., 5);
	
	vec3 color = vec3(n);
	
	gl_FragColor = vec4(color, 1.0);
}