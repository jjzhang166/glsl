#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy )-vec2(0.5,0.5);
	pos *= 4.;
	float s = sin(pos.x * mouse.x * 100.) * mouse.y * 2.;
	vec4 color = vec4(sin(time), sin(time*2.), sin(time*4.), 1.);
	if(pos.y - 0.02 > s || pos.y + 0.02 < s){
		color = vec4(1., 1., 1., 1.);
	}

	gl_FragColor = color;

}