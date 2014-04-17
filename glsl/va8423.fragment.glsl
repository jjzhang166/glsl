#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	float pitch = time * 10.0;
	float c = ceil(1.0 - mod(gl_FragCoord.y - pitch, 50.0));
	vec2 pos = gl_FragCoord.xy / resolution.xy;	
	
	if (pos.x < 0.4 || pos.x > 0.6 || (pos.x > 0.46 && pos.x < 0.54))
		c = 0.0;
	
	gl_FragColor = vec4(0.0, c, 0.0, 1.0 * c);
}