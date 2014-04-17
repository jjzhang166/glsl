#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float circle(vec2 pixel_pos, vec2 pos, float radius) {
	return pow(distance(pixel_pos, pos) < radius ? 1.0 : 0.0,1.0);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	

	
	float color = 0.0;
	color += circle(position,vec2(0.8,0.8),clamp(cos(time*2.0), 0.02,0.15))* pow(position.x*position.y,2.0);;
	color += circle(position,vec2(0.8,0.2),clamp(sin(time*1.0), 0.02,0.15))* pow(position.x*position.y,2.0);;
	color += circle(position,vec2(0.8,0.1),clamp(cos(time*0.5), 0.02,0.15))* pow(position.x*position.y,2.0);;
	
	color += circle(position,vec2(0.5,0.5),clamp(cos(time*2.0), 0.02,0.15))* pow(position.x*position.y,2.0);;
	color += circle(position,vec2(0.2,0.5),clamp(sin(time*1.0), 0.02,0.15))* pow(position.x*position.y,2.0);;
	color += circle(position,vec2(0.4,0.7),clamp(cos(time*0.5), 0.02,0.15)) * pow(position.x*position.y,2.0);

	
	//gl_FragColor = color + vec4(0.5, 0.5, 0.5, 1.0) * hash(color);
	gl_FragColor = color + vec4(color*0.5, color*0.5, color, 1.0);
		 
}