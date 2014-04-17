#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	float colorRojo = 0.0;
	float colorVerde=0.0;
	float i=0.0;
	float tam=0.07;
	float pi=3.1416;
	float tiempoCamino=5.0;
	float posx=time/tiempoCamino-floor(time/tiempoCamino);
	float posy=0.5;
	
	float aspectRatio=16.0/9.0;
	float tamBola=0.02;
	float tiempoBoca=0.25;
	
	float limiteBoca=0.0;
	
	if ( time/(tiempoBoca*2.0)-floor(time/(tiempoBoca*2.0)) < 0.5 )
	{
		limiteBoca=time/tiempoBoca-floor(time/tiempoBoca);
	}
	else
	{
		limiteBoca=1.0-(time/tiempoBoca-floor(time/tiempoBoca));
	}
	
	
	vec2 distanciaALasBolas= vec2((position.x)*aspectRatio,position.y-posy);
	vec2 distanciaAlPacMan=vec2((position.x-posx)*aspectRatio,(position.y-posy));
	vec2 vectorBoca=vec2(distanciaAlPacMan.x+tam*0.2,distanciaAlPacMan.y);
	
	for (int j=0; j<21; j++)
	{
		
		if(dot(distanciaALasBolas,distanciaALasBolas)<tamBola*tamBola
		  && ((float(j)*0.05>posx && float(j)*0.05<posx+0.75) || float(j)*0.05<posx-0.25))
			{
				
				colorRojo=0.99;
			}
		distanciaALasBolas.x-=0.05*aspectRatio;
		
	}
	
	
	if(dot(distanciaAlPacMan,distanciaAlPacMan)<tam*tam 
	    && dot(normalize(vectorBoca),vec2(1,0))<0.80+0.25*limiteBoca)
		{
		colorRojo =  0.99;
		colorVerde=0.99;
		}
	
	
	

	gl_FragColor = vec4( vec3( colorRojo, colorVerde, 0 ), 0 );

}