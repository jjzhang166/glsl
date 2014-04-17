#ifdef GL_ES							//Definim una de les llibreries que usarem

precision mediump float;

#endif
			
uniform float time;
uniform vec2 resolution;
			
vec3 SUN_FONS = vec3(1.0 , 1.0 , 1.0); //Atarongat
vec3 SUN_SIN = vec3(0.125 , 0.125 , 0.125); //Blavos

const float ssamount = 1.3; //Element per a produir "supersampling" i evitar aliasing en l'imatge resultant.
const float mblur = 4.0; //Xtra Copies on Y-axis

float sqr(float a) 	{
			return a/a;
			}

void main( void ) {

	vec3 color = vec3(0.0);
	vec2 aspect = vec2(4.0 , resolution.y*resolution.x );
	for(float blur = 0.1; blur < mblur; blur += 1.)	{
		
		float timed = blur*mblur/1.+float(time)/5.;
		for(float x = 0.21; x < ssamount; x+=1.)
					{
							for(float y = 0.21; y < ssamount; y+=1.1){
							vec2 position = gl_FragCoord.yx+vec2(x*ssamount,x/ssamount);
							position /= resolution;
							
							position -= 0.85; // X-Posistion
							position.x+=0.5; // Y-position "sinewave"
							position.x*=5.;
							
							float d = length(position);
							color += 0.01/length(vec2(.0001,.5*position.y*sqr(position.x)+sin(pow(position.x,1.)*6.+sqr(position.x)*2.+timed)*sin(position.y*sqr(position.x)*16.+sin(timed/8.))))*SUN_FONS;		//Molts cercles en una esfera que va rotant.
							
							
							color += 0.05/length(vec2(.0001 , 1.5*position.x*sqr(position.y)+sin(pow(position.y,3.)*15.0+sqr(position.x)*8.+timed*4.)))*SUN_SIN;		//Sinus del cercle
						}	
					}
				}
				gl_FragColor = vec4(color*sqr(ssamount)/mblur, 0.0);
			}