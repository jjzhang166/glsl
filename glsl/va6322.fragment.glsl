#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse;
	position.x = abs(tan(time/2.0)) * position.x;
	position.y = abs(sin(time/3.0)) * position.y;
	float t2 = sqrt(time / 4.0);
	
	vec4 color = vec4(position,t2,clamp(0.0,1.0,abs(atan(position.y/position.x))));
	
	if(color.x > 1.0) color = vec4(color.x,0,color.y,1);
	else if (color.x < 0.1) color = vec4(color.x,color.y,0,1);
	
	if(color.y > 1.0) color = vec4(color.x,0,color.y,1);
	else if (color.y < 0.1) color = vec4(color.x,color.y,0,1);
	
	gl_FragColor = color;
}