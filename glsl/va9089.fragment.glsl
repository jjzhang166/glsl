#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	/*Definition of Pac-Man and balls aspect varialbes, feel free to change them*/
	
							
	float tam=0.1;								//Radius of Pac-Man							
	float tiempoCamino=5.0;							//Time of Pac-Man journey
	float posy=0.5;								//Y position of Pac-Man center
	float tamBola=0.03;							//Radius of the balls
	float tiempoBoca=0.3;							//Time on wich Pac-Man opens his mouth
	float tamBoca = 0.25;							//Pac-Man mouth angle
	
	/*Other variables*/
								
	float colorRojo = 0.0;                                              	
	float colorVerde = 0.0;
	float colorAzul=0.0;
	float posx=time/tiempoCamino-floor(time/tiempoCamino);
	float aspectRatio=resolution.x/resolution.y;
	float distanciaBolas=tamBola*3.0;					
	int numBolas=int(1.0/distanciaBolas);					
	vec2 distanciaAlPacMan=vec2((position.x-posx)*aspectRatio,(position.y-posy));
	vec3 superficiePacman=normalize(vec3(distanciaAlPacMan.x/tam,distanciaAlPacMan.y/tam,sqrt(1.0-(distanciaAlPacMan.x*distanciaAlPacMan.x-distanciaAlPacMan.y*distanciaAlPacMan.y)/(tam*tam))));
	vec3 iluminacion=normalize (vec3((mouse.x-position.x,mouse.y-position.y,0.8)));
	vec2 vectorBoca=vec2(distanciaAlPacMan.x+tam*0.2,distanciaAlPacMan.y);
	float limiteBoca;
	vec2 distanciaALasBolas= vec2((position.x)*aspectRatio,position.y-posy);

	/*Sets the color of the pixel as red if it is inside a proper ball */
	
	for (int i=0; i<50; i++)
	{
		if(dot(distanciaALasBolas,distanciaALasBolas)<tamBola*tamBola
		  && ((float(i)*distanciaBolas>posx && float(i)*distanciaBolas<posx+0.75) || float(i)*distanciaBolas<posx-0.25))
			{
				colorRojo=0.99;
			}
		distanciaALasBolas.x-=distanciaBolas*aspectRatio;
		if(i==numBolas)
			break;
	}
	
	/*Changes the angle of the mouth between tamBoca and 0*/
	
	if ( time/(tiempoBoca*2.0)-floor(time/(tiempoBoca*2.0)) < 0.5 )
	{
		limiteBoca=time/tiempoBoca-floor(time/tiempoBoca);
	}
	else
	{
		limiteBoca=1.0-(time/tiempoBoca-floor(time/tiempoBoca));
	}
	
	/*Sets the pixel as yellow if inside of Pac-Man and not in mouth*/
	
	if(dot(distanciaAlPacMan,distanciaAlPacMan)<tam*tam 
	    && dot(normalize(vectorBoca),vec2(1,0))<(1.0-tamBoca)+0.05+tamBoca*limiteBoca)
		{
			colorAzul=   dot(superficiePacman,iluminacion);
			colorRojo =  0.3+0.7*colorAzul;
			colorVerde=  0.3+0.7*colorAzul;
			
		}
	
	gl_FragColor = vec4( vec3( colorRojo, colorVerde, pow(colorAzul,25.0) ), 0 );

}