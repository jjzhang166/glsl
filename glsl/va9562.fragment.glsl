#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	
	if(position.y < sin(position.x * 3.0 + time)*0.2 + 0.7 && position.y > sin(position.x * 3.0 + time)*0.2 + 0.4 )
	{
		float color = sin((position.x) + time*3.0);
		//gl_FragColor = vec4( color,0,0,0.0 );
	}
	else
	{
		float colorg = 0.0;
		colorg += sin(position.x*100.0 + time * 10.0);
		colorg += cos(position.y*100.0);
		
		float colorb = 0.0;
		colorb += sin(position.x*100.0 + time * 10.0);;
		colorb += cos((position.y + sin(position.x/10.0 + time * 4.5)/80.0)*100.0);
		gl_FragColor = vec4( 0.0,colorg,colorb,1.0 );	
	}

}