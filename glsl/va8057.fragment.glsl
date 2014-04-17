#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	
	
	
	

	// MADE BY CHAERIS!
	// French, 14 years old.
	// Made on Friday the 12th April 2013 around 12AM CET
	
	
	
	
	
	
	vec2 position = ( gl_FragCoord.xy - resolution.xy ) / length(resolution.xy) * 400.0 + mouse * 5.0;
	position.y += sin(position.x * 0.1 - time) * 2.0;
	position.x += sin(position.y * -0.03 - time) * 2.0;
	vec3 color;
	if(abs(position.x) < 358./3.) {
		color = vec3(1.0, 0.0, 0.0);
	}
	else if(abs(position.x) < 300. && abs(position.x) > 290. && abs(position.y) > 150. && abs(position.y) < 155.) color = vec3(0.0, 0.0, 0.0); 
	else if(abs(position.x) < 300. && abs(position.x) > 295. && abs(position.y) > 150. && abs(position.y) < 170.) color = vec3(0.0, 0.0, 0.0); 
	else if(abs(position.x) < 300. && abs(position.x) > 290. && abs(position.y) > 165. && abs(position.y) < 170.) color = vec3(0.0, 0.0, 0.0); 
	
	else if(abs(position.x) < 285. && abs(position.x) > 270. && abs(position.y) > 157.5 && abs(position.y) < 162.5) color = vec3(0.0, 0.0, 0.0); 
	else if(abs(position.x) < 275. && abs(position.x) > 270. && abs(position.y) > 150. && abs(position.y) < 170.) color = vec3(0.0, 0.0, 0.0); 
	else if(abs(position.x) < 285. && abs(position.x) > 280. && abs(position.y) > 150. && abs(position.y) < 170.) color = vec3(0.0, 0.0, 0.0); 
		
	else if(abs(position.x) < 265. && abs(position.x) > 255. && abs(position.y) > 157.5 && abs(position.y) < 162.5) color = vec3(0.0, 0.0, 0.0); 
	else if(abs(position.x) < 255. && abs(position.x) > 250. && abs(position.y) > 150. && abs(position.y) < 170.) color = vec3(0.0, 0.0, 0.0); 
	else if(abs(position.x) < 265. && abs(position.x) > 260. && abs(position.y) > 150. && abs(position.y) < 170.) color = vec3(0.0, 0.0, 0.0); 
	else if(abs(position.x) < 260. && abs(position.x) > 250. && abs(position.y) > 150. && abs(position.y) < 155.) color = vec3(0.0, 0.0, 0.0); 
		
	else if(abs(position.x) < 245. && abs(position.x) > 235. && abs(position.y) > 150. && abs(position.y) < 155.) color = vec3(0.0, 0.0, 0.0); 
	else if(abs(position.x) < 245. && abs(position.x) > 240. && abs(position.y) > 150. && abs(position.y) < 170.) color = vec3(0.0, 0.0, 0.0); 
	else if(abs(position.x) < 245. && abs(position.x) > 235. && abs(position.y) > 165. && abs(position.y) < 170.) color = vec3(0.0, 0.0, 0.0); 
	else if(abs(position.x) < 245. && abs(position.x) > 235. && abs(position.y) > 157.5 && abs(position.y) < 162.5) color = vec3(0.0, 0.0, 0.0); 
		
	else if(abs(position.x) < 230. && abs(position.x) > 220. && abs(position.y) > 157.5 && abs(position.y) < 162.5) color = vec3(0.0, 0.0, 0.0); 
	else if(abs(position.x) < 220. && abs(position.x) > 215. && abs(position.y) > 150. && abs(position.y) < 162.5) color = vec3(0.0, 0.0, 0.0); 
	else if(abs(position.x) < 230. && abs(position.x) > 225. && abs(position.y) > 150. && abs(position.y) < 170.) color = vec3(0.0, 0.0, 0.0); 
	else if(abs(position.x) < 225. && abs(position.x) > 215. && abs(position.y) > 150. && abs(position.y) < 155.) color = vec3(0.0, 0.0, 0.0); 
	else if(length(position.xy) > 273.5 && length(position.xy) < 278.5 && abs(position.y) > 160. && abs(position.y) < 170.) color = vec3(0.0, 0.0, 0.0);
		
	else if(abs(position.x) < 210. && abs(position.x) > 205. && abs(position.y) > 157.5 && abs(position.y) < 170.) color = vec3(0.0, 0.0, 0.0);
	else if(abs(position.x) < 210. && abs(position.x) > 205. && abs(position.y) > 150. && abs(position.y) < 155.) color = vec3(0.0, 0.0, 0.0);
		
	else if(abs(position.x) < 200. && abs(position.x) > 190. && abs(position.y) > 150. && abs(position.y) < 155.) color = vec3(0.0, 0.0, 0.0); 
	else if(abs(position.x) < 200. && abs(position.x) > 195. && abs(position.y) > 150. && abs(position.y) < 162.5) color = vec3(0.0, 0.0, 0.0);
	else if(abs(position.x) < 195. && abs(position.x) > 190. && abs(position.y) > 162.5 && abs(position.y) < 170.) color = vec3(0.0, 0.0, 0.0);
	else if(abs(position.x) < 200. && abs(position.x) > 190. && abs(position.y) > 165. && abs(position.y) < 170.) color = vec3(0.0, 0.0, 0.0); 
	else if(abs(position.x) < 200. && abs(position.x) > 190. && abs(position.y) > 157.5 && abs(position.y) < 162.5) color = vec3(0.0, 0.0, 0.0);
		
	else if(abs(position.x) < 358./3.*2.) color = vec3(1.0, 1.0, 1.0);
	else if(abs(position.x) < 400.) color = vec3(0.0, 0.0, 1.0);
	
		
	gl_FragColor = vec4(color * (-cos(position.x * 0.1 - time) * 0.3 + 0.7), 1.);
}