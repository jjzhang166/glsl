// added a bit of burning color

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


// Trapped by curiouschettai

void main( void ) {  
	vec2 uPos = ( gl_FragCoord.xy / resolution.x );//normalize wrt y axis
	//uPos -= vec2((resolution.x/resolution.y)/2.0, 0.5);//shift origin to center
	
	float multiplier = 0.002; // Grosseur
	const float step = 0.2; //segmentation
	const float loop = 4.0; //Longueur
	const float timeSCale = 1.05; // Vitesse
	
	vec3 blueGodColor = vec3(0.0);
	for(float i=1.0;i<loop;i++){		
		float t = time*timeSCale-step*i;
		vec2 point = mouse * i/5.0;
		float componentColor= multiplier/((uPos.x-point.x)*(uPos.x-point.x) + (uPos.y-point.y)*(uPos.y-point.y))/i;
		blueGodColor += vec3(componentColor, componentColor, componentColor);
	}
	
	
	vec3 color = vec3(0,0,0);
	color += pow(blueGodColor,vec3(1.1,1.1,0.8));
   
	
	gl_FragColor = vec4(color, 1.0);
}