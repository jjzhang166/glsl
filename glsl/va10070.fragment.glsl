#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

const int blendRate = 5;

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 pixel = 1./resolution;
	vec4 me;

	float mradius = 0.02;//0.07 * (-0.03 + length(zoomcenter - mouse));
	if (length(position-mouse) < mradius)
	{
		me.r = 0.5+0.5*sin(time * 1.234542);
		me.g = 0.5+0.5*sin(3.0 + time * 1.64242);
		me.b = 0.5+0.5*sin(4.0 + time * 1.444242);
	}
	else
	{	
		vec4 sample = vec4(0.0);
		
		for (int i = -blendRate; i <= blendRate; i++)
		{
			for (int j = -blendRate; j <= blendRate; j++)
			{
				vec2 offset = position + (vec2(pixel.x, 0.0) * float(i));
				sample +=texture2D(backbuffer, position + pixel * vec2(float(i), float(j)));
			}
		}
		
		me = sample * 1. / pow(float(blendRate * 2 + 1),2.0);
	}
	
	gl_FragColor = me * 0.99;
}
