#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	vec4 color = vec4(0.0,0.0,0.0,0.0);
	color.x = sin((time*15.0) + length(gl_FragCoord.xy)/2.0);
	color.x = (color.x + 1.0)/2.0; 
	color.y = sin((time*8.0) - length(vec2((gl_FragCoord.x - (resolution.x * mouse.x)), gl_FragCoord.y - (resolution.y*mouse.y))/2.0));
	color.y = (color.y + 1.0)/2.0; 
	
	gl_FragColor = vec4(color.x*0.8,color.y*0.8,mouse.x*0.5,color.a);
	
}