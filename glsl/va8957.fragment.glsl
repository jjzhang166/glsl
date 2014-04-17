//Just learning stuff...

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 oldDotPos = vec2(0.1, 0.1);
	vec2 dotPos = oldDotPos;
	dotPos.x = (oldDotPos.x * cos(time) - oldDotPos.y * sin(time)) + 0.5;
	dotPos.y = (oldDotPos.x * sin(time) + oldDotPos.x * cos(time)) + 0.5;

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = distance(position, vec2(0.5)) * 5.0;
	float otherColor = distance(position, dotPos) * 20.0;
	
	vec3 finalColor = vec3(0.0, 1.0 - otherColor, 1.0 - color);

	
	if(mouse.x * resolution.x < gl_FragCoord.x) {
		finalColor.x = 1.0 - finalColor.x;	
	}
	
	if(mouse.y * resolution.y < gl_FragCoord.y) {
		finalColor.y = 1.0 - finalColor.y;	
	}
	
	
	gl_FragColor = vec4( vec3(finalColor), 1.0 );

}