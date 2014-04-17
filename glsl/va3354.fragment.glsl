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
	
	float x = 0.0;
	float y = 0.0;
	float shade = 0.0;
	pos.x += 0.5; 
	for(float i = -1.0; i < 1.0; i+=0.1) {
		pos.x -= 0.05; 
		x = log(length(pos)*5.5);
		y = pos.y - i;
		shade += x-y*usint*6.;
	}

	gl_FragColor = vec4( vec3( shade ) , 1.0 );

}