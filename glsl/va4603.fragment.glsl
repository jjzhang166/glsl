// added a bit of burning color

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//firefly

void main( void ) {  
	vec2 uPos = ( gl_FragCoord.xy / resolution.y );
	uPos -= vec2((resolution.x/resolution.y)/2.0, 0.5);
	
	float multiplier = 0.00005;
	const float step = 0.2;
	const float loop = 25.0; 
	const float timeSCale = 1.05; 
	
	vec3 green = vec3(0.0);
	for(float i=1.0;i<loop;i++){		
		//float t = time*timeSCale-step*mouse.x * i;
		float t = time * (i * 0.05);
		vec2 point = vec2((0.75*sin(t) * mouse.x), 0.5*sin(t*.02) * mouse.y);
		point += vec2(0.75*cos(t*0.1), 0.5*sin(t*0.3));
		point /= 4. * sin(i);
		float componentColor= multiplier/((uPos.x-point.x)*(uPos.x-point.x) + (uPos.y-point.y)*(uPos.y-point.y))/i;
		green += vec3(componentColor/2.0, componentColor/1.0, componentColor/9.0);
	}
	
	
	vec3 color = vec3(0,0,0);
	color += pow(green,vec3(1.1,1.1,0.8));
   
	
	gl_FragColor = vec4(color, 1000.0);
}