#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	float height = 0.2;
	float width = 0.1;
	float radians = 3.14 * time;
	float cosine = cos(radians);
	float sine = sin(radians);
	
	gl_FragColor = vec4(0.1, 0.1, 0.0, 1.0);
	
	vec2 temp = position - mouse;
	float sourcex = (temp.x * cosine + temp.y * sine);
	float sourcey = (temp.y * cosine - temp.x * sine);
	if(sourcex > (-width) && sourcex < (width) && sourcey > (-height) && sourcey < (height)) {
		gl_FragColor = vec4(1.0, 0.0, 1.0, 1.0);
	}

}