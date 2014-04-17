#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse; //Somewhere betwen 0 and 1
uniform vec2 resolution; //Size of window / size Modifier

bool drawSquare( vec2 pos, float r )
{
	vec2 target = mouse * resolution;
	
	if (((target.x - pos.x) < r) && ((target.y - pos.y) < r))
		if (((pos.x - target.x) < r) && ((pos.y - target.y) < r))
			return true;
	
	return false;
}

void main( void ) {
	
	vec4 color = vec4(1.0, gl_FragCoord.y / resolution.x, 0.0, 1.0);	
	vec2 position = gl_FragCoord.xy;
	
	vec4 squareColor = vec4( 0.0, 0.0, 0.0, 0.0);
	
	if(drawSquare( position, 240.0))
	{	
		squareColor.r = mod(time * 0.5, 1.0);	
		squareColor.g = sin(time);
		squareColor.b = mod(time, 1.0);
		squareColor.a = 0.1;
	}
	
	
	gl_FragColor = color + squareColor;

}