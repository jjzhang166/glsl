#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float MAX = 50.0;

vec2 pow2(vec2 z) { 		
	float a = z.x; 
	float b = z.y; 
	float c = z.x; 
	float d = z.y; 
	
	float r = a*c - b*d; 
	float i = a*d + b*c; 
	return vec2(r,i); 
}

vec2 f(in vec2 z) {
	return pow2(z) + mouse;
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	vec2 z0 = position;
	vec2 z = z0;
	
	for (float i = 0.; i <= MAX; i++) {
		z = f(z);
		if (length(z - z0) > 3.5) {
			gl_FragColor = vec4(vec3(i / MAX), 1.0);
		}
	}
	
	
	
	gl_FragColor = vec4(vec3(0.0), 1.0);

}