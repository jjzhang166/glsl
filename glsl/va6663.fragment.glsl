// schmid

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float svin(float p) { return sin(p*6.28) * 0.5 + 0.5; }

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );// + mouse / 4.0;
	vec2 pc = position * 2.0 - vec2(1.0, 1.0);
	float r = sqrt(dot(pc, pc));
	float a = atan(pc.y,pc.x);
	gl_FragColor = vec4( floor(r+svin(a*200.+time*0.1)), 0.0, 0.0, 1.0 );
}
