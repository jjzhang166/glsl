#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	const float max_rows = 10.0;
	float length = 1.0;
	vec3 color = vec3(0.6, 0.6, 0.75);
	float barHeight = 4.0;
	float speed = 60.0;
	
	float sectionedPos = mod(gl_FragCoord.y + time * speed, barHeight * max_rows);
	float row = floor(sectionedPos / barHeight) + 1.0;
	
	if(mod(sectionedPos, barHeight) < barHeight/2.0)
	{
		if(position.x < 1.0 - row/max_rows)
		{
			color.x *= 0.05;
			color.y *= 0.05;
			color.z *= 0.25;
		}
	}
	else
	{
		color *= 0.0;	
	}
	
	
	gl_FragColor = vec4( color, 1.0 );
}