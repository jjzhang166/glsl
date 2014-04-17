#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 mouse;
uniform vec2 resolution;

float pixelsize = 32.0;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy);
	
	vec3 color = vec3(0.0);
	
	float  xpos = floor(position.x/pixelsize);
	float  ypos = floor(position.y/pixelsize);
	float col = mod(xpos,2.);
	if (mod(ypos,2.)>0.)
		if (col>0.)
			col=0.;
		else
			col = 1.;	
	color = vec3(col, col , col);
		
	gl_FragColor = vec4( color, 1.0 );

}