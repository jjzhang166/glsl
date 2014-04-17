#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float linePos = mouse.x;
	
	float width = mouse.y / 2.0;
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	float color = 0.0;
	
	if (position.x > linePos - width && position.x <= linePos)
	{
	    color = position.x - (linePos - width);
	    color *= 10.0;
	}
	else if (position.x < linePos + width && position.x >= linePos)
	{
	   color = (linePos + width) - position.x;
	   color *= 10.0;
	}

	gl_FragColor = vec4( color, color, color, 1.0 );

}