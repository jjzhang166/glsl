#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float pseudorandom(vec2 where) {
	return fract(7457.0 * (7.0 + sin(7.0 * where.x))
		            * (5.0 + cos(9.0 * where.y)));
}

vec3 pseudo3(vec2 where) {
	return normalize(vec3(pseudorandom(where),
		    pseudorandom(where + vec2(1.)),
		    pseudorandom(where + vec2(5.))));
}

vec3 sample(vec2 where, float width) {
	vec2 corner = where - mod(where, width);
	vec3 sum = pseudo3(corner)
	         + pseudo3(corner + vec2(width, 0))
	         + pseudo3(corner + vec2(0, width))
	         + pseudo3(corner + vec2(width));
	return sum / 4.0;
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	vec3 color = vec3(0.0);
	
	float width = 1.0;
	for(float i = 0.0; i < 8.0; i++) {
		color += sample(position, width)
			* width * width;
		
		width *= 0.5;
	}

	gl_FragColor = vec4( color, 1.0 );
}