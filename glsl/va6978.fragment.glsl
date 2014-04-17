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
			k += .1-.002/(t-.001);
		else
			k += .1+.001/(t+.01);
	}
	for(int i = 0; i<2; i++)
	{
		float t = position.y-(sin(time*10.0)*.05+.02*sin(float(i)*5.0+3.0*position.x+(.3*float(i))*time+sin(position.x*8.0+time)*5.0));
		if(t>.0)
			k += .1-.002/(-.001-t);
		else
			k += .1+.001/(-t+.01);
	}
	gl_FragColor = vec4(vec3(.7,.2,1.0)*(k-sin(2.0*position.y-.4))*vec3(.7,.2,1.0)*(k-sin(2.0*position.y-.4)), 1.0 );
}