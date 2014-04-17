// by @inaniwa3

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) / 10.0;
	gl_FragColor = vec4( 0.0, 0.0, sin(position.y/(position.x+0.015)*time/5.0*cos(0.5*time-position.x-position.y)), 1.0 );
}
