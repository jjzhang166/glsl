#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	if (mouse.x < 0.1) {
		gl_FragColor = vec4(step(distance(p,vec2(0.3)), 0.1)+step(distance(p,vec2(0.7)), 0.1));
		return;
	}

	float c = texture2D(backbuffer, p).x;
	gl_FragColor = vec4(c);
	if (c < 0.01) {
		float d = 0.0;
		d = max(d, texture2D(backbuffer, p+(vec2(1.0, 0.0))/resolution).x - 0.002);
		d = max(d, texture2D(backbuffer, p-(vec2(1.0, 0.0))/resolution).x - 0.002);
		d = max(d, texture2D(backbuffer, p+(vec2(0.0, 1.0))/resolution).x - 0.002);
		d = max(d, texture2D(backbuffer, p-(vec2(0.0, 1.0))/resolution).x - 0.002);
		d = max(d, texture2D(backbuffer, p+(vec2(1.0, 1.0))/resolution).x - 0.002);
		d = max(d, texture2D(backbuffer, p+(vec2(1.0, -1.0))/resolution).x - 0.002);
		d = max(d, texture2D(backbuffer, p+(vec2(-1.0, 1.0))/resolution).x - 0.002);
		d = max(d, texture2D(backbuffer, p-(vec2(1.0, 1.0))/resolution).x - 0.002);
		gl_FragColor = vec4(d);
		return;
	}

}