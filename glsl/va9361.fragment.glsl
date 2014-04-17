#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void ) {
	vec2 position = gl_FragCoord.xy/resolution.xy;
	vec3 color = vec3(0.5+(sin(position.x*20.+time-mouse.x*5.)/2.),0.5+(cos(position.y*20.-time+mouse.y*5.)/2.), mouse.x+mouse.y);
	gl_FragColor = vec4 (color-(distance (position, mouse)*2.), 1.);
	gl_FragColor = vec4( mod( position.x+mouse.x, 255.), mod (position.y+mouse.y, 255.), mod (mouse.x+mouse.y , 255.) , 1.0 );
}