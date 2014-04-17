#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float size = mouse.x;
	vec4 color;
	vec2 pos = mod(gl_FragCoord.xy,vec2(size));
	
	if ((pos.x > (size / 2.0))&&(pos.y > (size / 2.0))){
		color=vec4(1.0, 1.0, 1.0, 1.0);
	}
	if ((pos.x < (size / 2.0))&&(pos.y < (size / 2.0))){
		color=vec4(1.0, 1.0, 1.0, 1.0);
	}
	if ((pos.x < (size / 2.0))&&(pos.y > (size / 2.0))){
		color=vec4(0.0, 0.0, 0.0, 1.0);
	}
	if ((pos.x > (size / 2.0))&&(pos.y < (size / 2.0))){
		color=vec4(0.0, 0.0, 0.0, 1.0);
	}
	gl_FragColor = color;
}