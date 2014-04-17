#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {
	vec2 pos = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;
	float c =  sin(pos.x * abs(sin(time*0.1))*100.0) - pos.y*10.0;
	float d =  sin(pos.y * abs(sin(time*0.1))*300.0) - pos.x*abs(sin(time))*60.0;
	gl_FragColor = vec4( vec3( sin(d), c, c ), 1.0 );
}