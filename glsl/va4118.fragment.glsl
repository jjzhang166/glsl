#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 pos = gl_FragCoord.xy / resolution - mouse;
	gl_FragColor = vec4( vec3( 1.0, 0.0, sqrt(pos.x*pos.x+pos.y*pos.y)*2.0+sin(time*4.0)/2.0+0.5), 1.0 );
}