#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// I heared you liked colors

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	float color[4];
	int j = 0;
	for(int i = 0; i < 4; i++)
	{
		float a = position.x*sin(time * 2.) - float(i);
		float b = position.y*cos(time * 2.) - float(i);
		if(j == 1)
			color[1] = sin(a * a + b * b);
		else if(j == 2)
			color[2] = sin(a * a + b * b);
		j++;
		if(j > 3)
			j = 0;
	}
	color[0] = sin(time);
	color[1] = sin(color[1]);
	color[2] = cos(color[2]);
	
	gl_FragColor = vec4( vec3( color[0], color[1], color[2] ), 1.0 );
}