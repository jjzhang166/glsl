#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float distance(vec2 pos){
	float height = sin(pos.x * mouse.x * 200.0 + time) / 5.0;
	return abs(height - pos.y*mouse.y*20.0);
}

void main( void ) {
	vec3 color = vec3(0, 0.5, 1) * (0.5 - distance(gl_FragCoord.xy / resolution - vec2(0.5, 0.5)));
	
	gl_FragColor = vec4(color, 1.0 );
}