#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	vec3 color;
	float sum = 0.0;
	float size = 25.0;
	float r = 2.0;
	float g = 1.0;
	for (int i = 0; i < 2; ++i) {
		vec2 position = resolution / 2.0;
		position.x += sin(time + 10.0 * float(i)) * 50.0;
		position.y += cos(time+ 5.0 * float(i)) * 50.0;
		
		float dist = length(gl_FragCoord.xy - position);

		sum += size / pow(dist, g);
	}
	
	if (sum > r) color = vec3(1,1,1);
	
	gl_FragColor = vec4(color, 1);
}