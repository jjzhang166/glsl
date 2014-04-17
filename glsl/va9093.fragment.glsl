#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float y = sqrt(mod(pow(gl_FragCoord.x - mod(gl_FragCoord.x,10.)/10., 2.),4.))*200.;
	if(distance(y, gl_FragCoord.y) < 10.)
	{
		gl_FragColor = vec4(1.0,1.0,0.4,0.0);
	}
}