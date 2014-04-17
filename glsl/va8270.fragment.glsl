#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec3 color = vec3(1.0, 1.0, 1.0);
	
	for(int i = 30; i>0; i--)
	{
		float fi = float(i);
		vec2 center = vec2(0.5, 0.5);
		vec2 diff = position - center;
		float hyp = sqrt(pow(diff.x, 2.0) + pow(diff.y, 2.0));
		if(hyp < fi / 30.0 && mod(fi,2.0) == 0.0)
		{
			color.x = 1.0;
			color.y = 0.0;
			color.z = 0.0;
		}
		if(hyp < fi / 30.0 && mod(fi,2.0) == 1.0)
		{
			color.x = 0.0;
			color.y = 1.0;
			color.z = 0.0;
		}
	}

	gl_FragColor = vec4( color, 1.0 );

}