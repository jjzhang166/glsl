#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) / 4.0;

	vec3 color = vec3(1.0,1.0,1.0);
	
	//float t = time/10.0+position.x;
	float t = 0.45;
	
	mat3 rotx = mat3(1.0,0.0,0.0,
			0.0,cos(t),-sin(t),
			0.0,sin(t),cos(t));
	mat3 roty = mat3(cos(t),0.0,sin(t),
	 		0.0,1.0,0.0,
			-sin(t),0.0,cos(t));
	mat3 rotz = mat3(cos(t),-sin(t),0.0,
			sin(t),cos(t),0.0,
			0.0,0.0,0.1);
	
	float it = mod(position.x, 0.5);
	
	for (float x = 0.0; x <= 20.0; x++){
		color = color*rotx;
				
		if (sin(position.x*300.0)>0.5){
			break;
		}
	}

	for (float x = 0.0; x <= 20.0; x++){
		color = color*roty;
				
		if (sin(position.x*310.0)>0.5){
			break;
		}
	}
	
	for (float x = 0.0; x <= 20.0; x++){
		color = color*rotz;
				
		if (sin(position.x*320.0)>0.5){
			break;
		}
	}
	
	gl_FragColor = vec4( color, 1.0 );
}