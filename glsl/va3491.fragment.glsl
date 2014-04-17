#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float red = 0.0;
	float green = 0.0;
	float blue = 0.0;

	for(float y=0.0;y<100.0;y++)
	{
		if(position.x<1.0/y*position.y)
		{
			blue=1.0/y;
			green+=0.015;
		}
		else
		{
			red=blue/3.0;
		}
	}
	gl_FragColor = vec4( vec3(red,green,blue),1.0 );

}