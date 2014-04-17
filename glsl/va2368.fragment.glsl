#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	float val1 = sin(time*position.x);
	float val2 = cos(sqrt(time)*position.y);
	gl_FragColor = vec4(val1,val2,0,1);

}