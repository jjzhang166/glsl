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
	
	vec4 col = vec4(0.0,0.0,0.0,0.0);
	
	float dist = distance(position, vec2(0.0, 0.0));
			      
	if (mod((position.x+time/10.0), 0.5 ) < 0.5*sin(dist*time)*cos(dist)){
		col = vec4(mod((position.x+time/5.0), 0.2 )+0.6,
			   mod((position.x+time/7.0), 0.2 )+0.1,
			   mod((position.x+time/7.0), 0.2 )+0.4,
			   0.0);
	}
	
	//col = vec4(position.x,0.0,0.0,0.0);
	
	float radius = 0.3;
	vec2 center = vec2(-0.5, -0.5);
	
	gl_FragColor = col;

}