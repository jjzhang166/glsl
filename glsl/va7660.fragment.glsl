#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float amplitude = 5.0 + mouse.y*3.0;
	float frequency = 5.0 + mouse.x *3.0;
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	float xPosition = mod(time,10.0)/10.0;
	float yPosition = amplitude*((sin(xPosition*frequency))/12.0) + 0.5;
	
	float xBuffer = 0.002;
	float yBuffer = 0.005;
	
	bool xUpper = position.x < (xPosition + xBuffer);
	bool xLower = position.x > (xPosition - xBuffer);

	bool yUpper = position.y < (yPosition + yBuffer);
	bool yLower = position.y > (yPosition -yBuffer);


        if( yUpper && yLower && xUpper && xLower )
		gl_FragColor = vec4( vec3(1.0), 1.0 );
	else
		gl_FragColor = vec4( vec3(0.0 ), 1.0 );
}