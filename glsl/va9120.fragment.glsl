#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	/*Definition of Pac-Man and balls aspect and behavior varialbes*/
	
							
	float tam=0.15;								//Radius of Pac-Man							
	float tiempoCamino=4.0;							//Time of Pac-Man journey
	float posy=0.4;								//Y position of Pac-Man center
	float tamBola=0.04;							//Radius of the balls
	float tiempoBoca=0.25;							//Time on wich Pac-Man opens his mouth
	float tamBoca = 0.25;							//Pac-Man mouth angle
	
	/*Other variables*/
								
	float tiempo=time+tiempoCamino*0.25;					//Changes the time coord in order to change the start position
	float colorRojo = 0.0;                                              	//Sets the initial value of red color
	float colorVerde = 0.0;							//Sets the initial value of green color
	float colorAzul=0.0;							//Sets the initial value of blue color
	float posx=tiempo/tiempoCamino-floor(tiempo/tiempoCamino);		//Sets the x position of PacMan as a function of the time
	float aspectRatio=resolution.x/resolution.y;				//Defines the aspect ratio of the screen
	float distanciaBolas=tamBola*3.0*aspectRatio;				//Sets the distance between balls
	int numBolas=int(1.0/distanciaBolas);					//Sets the number of balls
	vec2 distanciaAlPacMan=vec2((position.x-posx)*aspectRatio,		//Defines a vector from the pixel to PacMan position
				    (position.y-posy));
	vec3 superficiePacman=vec3(						//Defines a vector perpendicular to PacMan surface
		distanciaAlPacMan.x/tam,
		distanciaAlPacMan.y/tam,
		sqrt(1.0-(distanciaAlPacMan.x*distanciaAlPacMan.x+
			  distanciaAlPacMan.y*distanciaAlPacMan.y)/
		     (tam*tam)));
	vec3 rebotePacMan=2.0*superficiePacman*					//Defines a vector in the direction 
		dot(superficiePacman,vec3(0.0,0.0,1.0))-			//of the light reflected by this point of PacMan
		vec3(0.0,0.0,1.0);
	vec3 camera=normalize(vec3(((mouse.x-position.x)*			//Defines the direction from the point to the camera
					 aspectRatio,mouse.y-
					 position.y,0.3)));
	vec2 vectorBoca=vec2(distanciaAlPacMan.x+tam*0.2,			//Distance to the vertex of the mouth
			     distanciaAlPacMan.y);
	float limiteBoca;							//Defines the boundaries of the mouth, depending of time
	vec2 distanciaALasBolas= vec2((position.x)*aspectRatio,			//Defines a vector from the pixel to the 1st Ball center
				      position.y-posy);
	vec3 superficieBolas;							//Defines a vector perpendicular to the ball surface
	vec3 reboteBolas;							//Defines a vector in the direction
										//of the light reflected by this point of the ball
	/*Sets the color of the pixel as red if it is inside a proper ball, also sets the volume effect */
	
	for (int i=0; i<10; i++)						//Paints the balls with a limit of 10
	{
		superficieBolas=vec3(distanciaALasBolas.x/tamBola,
				     distanciaALasBolas.y/tamBola,
				     sqrt(1.0-(
					     distanciaALasBolas.x*distanciaALasBolas.x+
					     distanciaALasBolas.y*distanciaALasBolas.y)/
					  (tamBola*tamBola)));
		reboteBolas=2.0*superficieBolas*dot(superficieBolas,vec3(0.0,0.0,1.0))-
			vec3(0.0,0.0,1.0);
		if(dot(distanciaALasBolas,distanciaALasBolas)<			//If the square of the distance to the balls is lesser than 
		   tamBola*tamBola 						// the square of Ball radius
		   &&								
		   ((float(i)*distanciaBolas>posx				// the possition of the ball i is greater than x of PacMan
		      && 							
		     float(i)*distanciaBolas<posx+0.5) 				// the ball is in front of PacMan but not very far away
		    || 
		    float(i)*distanciaBolas<posx-0.5))				// the ball is at the begining of the screen but not near PacMan
			{
				
				colorAzul= dot(reboteBolas,camera);		//The amount of light set by the dot of light and camera vectors
				if (colorAzul<0.0)				// if dot is <0
				{
					colorRojo=0.4+0.6*(1.0+colorAzul);	//Just set the amount of red without increase the light
					colorAzul=0.0;
				}
				else
				{
				
					colorAzul=pow(colorAzul,4.0);		//Sets the amount of light as the dot
					colorVerde= colorAzul;
					colorRojo=0.99;
				}
			}
		distanciaALasBolas.x-=distanciaBolas*aspectRatio;		//Sets the x position of the next ball
		if(i==numBolas)							//Break the for loop if we don't need to paint more balls
			break;
	}
	
	/*Changes the angle of the mouth between tamBoca and 0*/
	
	if ( tiempo/(tiempoBoca*2.0)-floor(tiempo/(tiempoBoca*2.0)) < 0.5 )	//If we are in the 1st halve of the mouth movement
	{
		limiteBoca=tiempo/tiempoBoca-floor(tiempo/tiempoBoca);		//We increase the mouth angle with time
	}
	else									// if not
	{
		limiteBoca=1.0-(tiempo/tiempoBoca-floor(tiempo/tiempoBoca));	//We decrease the mouth angle with time
	}
	
	/*Sets the pixel as yellow if inside of Pac-Man and not in mouth, also sets the volume effect*/
	
	if(dot(distanciaAlPacMan,distanciaAlPacMan)<tam*tam 			//if the distance from the point to PacMan is lesser than Pacman radius
	    && dot(normalize(vectorBoca),vec2(1,0))<				// and the point is not in the mouth
	   	(1.0-tamBoca)+0.05+tamBoca*limiteBoca)
		{
			
			colorAzul=   dot(rebotePacMan,camera);			//The amount of light set by the dot of light and camera vectors
			if (colorAzul<0.0)					// if dot is <0
			{
				
				colorRojo=0.4+0.6*(1.0+colorAzul);		//Just set the amount of red as the dot without increase the light
				colorVerde=0.4+0.6*(1.0+colorAzul);
				colorAzul=0.0;
			}
			else
			{
				colorRojo =  0.99;				//Sets the amount of light as the dot
				colorVerde=  0.99;
				colorAzul=pow(colorAzul,4.0);
			}
			
		}
	
	gl_FragColor = vec4( vec3( colorRojo, colorVerde, colorAzul ), 0 );	//Output

}