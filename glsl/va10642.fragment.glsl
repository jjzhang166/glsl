#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	float c = 0.0;
	float a = mod(gl_FragCoord.y + time*25.0, 10.0);
	if(a > 5.0)
		c += 0.2;
	gl_FragColor = vec4(c);

}