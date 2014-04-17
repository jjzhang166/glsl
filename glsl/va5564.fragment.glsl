#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 relativePosition = (position - vec2(0.5, 0.5)) / vec2(resolution.y/resolution.x, 1.0); // aspect ratio correction
	
	
	float color = 0.0;
	float distance = sqrt(relativePosition.x*relativePosition.x + relativePosition.y*relativePosition.y);
	float angle = atan(relativePosition.y, relativePosition.x);
	color = abs(sin(distance*100.0 - angle*10.0 + time*10.0));
	color = color*color*3.0 * (2.0 - color);

	float d = min(1.0, distance*distance*10.0);
	//fColor *= d;	

	
	float fColor = sin(angle-time*10.0+distance*100.0)*0.5 + sin(angle+1.2+time*5.0+distance*300.0)*0.3 + color*0.3*d;

	gl_FragColor = vec4( fColor, fColor, fColor, 1.0 );

}