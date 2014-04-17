#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int starCount = 100;

void main( void ) {
	float sum = 0.0;
	vec2 size = resolution / 300.0;
	
	for (int i = 0; i < starCount; ++i) {
		vec2 position = resolution / 2.0 * vec2(cos(float(i) * 5.0), 1);
		vec2 speed    = vec2(1, float((starCount / -2 + i)) / 30.0);
		
		float t = (float(i) + time);
		
		
		
		position.y += float(20 * i - 10 * starCount);

		position += tan(t) * (speed * resolution);
		
		sum += size.x * (position.x / resolution.x) / length(gl_FragCoord.xy - position);
	}
	
	gl_FragColor = vec4(sum * 0.5, sum * 0.5, sum, 1);
}