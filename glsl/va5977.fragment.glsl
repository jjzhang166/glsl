#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//by @juju2143
void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) / 4.0;

	gl_FragColor = vec4(abs(sin(position.x*50.+position.y*20.-(time/2.) )), abs(sin(position.y*30.-(time/2.) )), abs(sin(position.x*20.+position.y*50.-(time/2.) )), 1.0 );
}