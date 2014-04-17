#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	float value = (sin(position.x*20.0+(time*7.0)) * 0.25 +0.5);
	
	vec4 color = vec4(0.0,0.0,0.0,0.0);
	
	if((position.y <= value+0.01) && (position.y >= value-0.01))
		color = vec4(1.0,0.0,0.0,1.0);
	else
		color = vec4(0.0,0.0,0.0,1.0);
	
	value = (cos(position.x*20.0+(time*7.0)) * 0.25 +0.5);
	
	if((position.y <= value+0.01) && (position.y >= value-0.01))
		color += vec4(0.0,0.0,1.0,1.0);
	else
		color += vec4(0.0,0.0,0.0,1.0);
		
	value = (sin(position.x*20.0+(time*7.0)+3.14) * 0.25 +0.5);
	if((position.y <= value+0.01) && (position.y >= value-0.01))
		color += vec4(0.0,1.0,0.0,1.0);
	else
		color += vec4(0.0,0.0,0.0,1.0);
	
	if (position.y >= 0.5 && position.y <= 0.502)
		color += vec4(0.0,1.0,0.0,1.0);
	
	if (position.y >= 0.5 && position.y <= 0.502)
		color += vec4(1.0,1.0,1.0,1.0);
	
	if(position.x >= 0.5 && position.x <= 0.51 && (position.y <= value+0.01) && (position.y >= value-0.01))
		color = vec4(1.0,1.0,1.0,1.0);
	
	gl_FragColor = color;
}