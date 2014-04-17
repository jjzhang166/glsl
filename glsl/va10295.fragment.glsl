#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
	float speed = 4.0;
	
	float rel = resolution.y / resolution.x;
	vec2 pos = gl_FragCoord.xy / resolution.xy;
	vec2 dir = vec2(mouse.xy - pos);
	dir.y = dir.y * rel;
	float dist = sqrt((dir.x * dir.x) + (dir.y * dir.y));
	
	if (dist < 0.01) {
		vec4 color = vec4 (
			0.75 + 0.25*sin(time * speed),
			0.5 + 0.25*sin((time + 2.0) * speed),
			0.5 + 0.25*sin((time + 4.0) * speed),
			1
			);
		gl_FragColor=color;
	}
	else {
		vec4 prevColor = texture2D(backbuffer, pos + dir * (dist * 0.5));
		gl_FragColor = prevColor;
	}
}