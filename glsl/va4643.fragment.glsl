#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main(void) {;
	float pos_x = gl_FragCoord.x;
	float pos_y = gl_FragCoord.y;
	
	vec4 Color = vec4(abs(cos(time)),0,0,1);
	if (pos_y == sin(pos_y)){
		Color = vec4(0,0,0,1);
	}
	gl_FragColor = Color;
}