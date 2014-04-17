#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) / 4.0;
	float k = .0;
	
	
	for(int i = 0; i<2; i++)
	{
		float t = position.y-(.18+.02*sin(float(i)*3.0+2.0*position.x+(.2+.3*float(i))*time));
		if(t<.0)
			k += .1-.0004/(t-.001);
		else
			k += .1+.0002/(t+.005);
	}
	for(int i = 0; i<2; i++)
	{
		float t = position.y-(.1+.02*sin(float(i)*5.0+3.0*position.x+(.1+.3*float(i))*time));
		if(t>.0)
			k += .1-.0004/(-.001-t);
		else
			k += .1+.0002/(-t+.005);
	}
	gl_FragColor = vec4( vec3(.4,.8,1.0)*(k-sin(2.0*position.y-.4)), 1.0 );

}