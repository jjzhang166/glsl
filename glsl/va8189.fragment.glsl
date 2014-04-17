//@T_SRTX1911

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = (( gl_FragCoord.xy / resolution.xy ) * 2.0) - 1.0;
	position.x = position.x * (resolution.x / resolution.y); //Fix aspect
	
	
	//float g = position.y * 0.5 + 0.5;
	//vec4 col = vec4(position, g, 1.0);
	
	vec4 col = vec4(1.0);
	
	if((position.x <= 0.5 && position.x >= 0.0) && 
	   (position.y <= 0.5 && position.y >= 0.0)){
		col = vec4(1.0, position.x * cos(time * 1.5) * 1.5, position.y * sin(time * 2.0) * 1.5, 1.0);
	}
	
	float radius = 0.3;
	vec2 center = vec2(-0.5, -0.5);
	if(length(position.xy - center) <= radius){
		col = vec4(0.0, 1.0, 0.0, 1.0);
	}
	
	gl_FragColor = col;

}