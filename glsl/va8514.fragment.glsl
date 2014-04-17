#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
float x=0.0;
float noise(float x)
{
	return fract(1111. * sin(x * 11111.0 + 111.) + 11.);	
}

void main( void ) {
		
	vec2 position = ( gl_FragCoord.x / resolution.xy * 1.) - 1.0;
	position.x *= x / 1.0;
		
	vec3 color;

	for(float i = 0.0; i < 9.0; i++)
	{		
		color +=  max(vec3(0.0), (0.05 - abs(sin(position.x * i * 0.8 + time + i * 0.3) - vec3(position.y)) * .2) * 3.) *
			vec3(i * 0.125, i * 0.15 + 0.2, i * 0.3 + 0.5);
	}
	
	color *= 2.;
	gl_FragColor = vec4( color, 1.0 );
	
}