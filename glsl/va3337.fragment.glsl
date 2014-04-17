// by rotwang

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void ) {

	vec2 unipos = ( gl_FragCoord.xy / resolution );
	vec2 pos = unipos*2.0-1.0;
	float sint = sin(time);
	float usint = sint*0.5+0.5;
	
	float x = log(length(pos)*4.0);
	float y = abs(pos.y);
	float shade = x+y*usint*8.0;

	gl_FragColor = vec4( vec3( shade ) , 1.0 );

}