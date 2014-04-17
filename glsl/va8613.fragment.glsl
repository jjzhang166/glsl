#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void)
{
	const int kSize = 7;
	vec3 c[kSize*kSize];
	int n = 0;
	for (int i=-kSize; i < kSize; ++i)
	{
		for (int j=-kSize; j < kSize; ++j)
		{
			c[n] = texture2D(iChannel0, (gl_FragCoord.xy+vec2(i,j)) / resolution.xy).rgb;
			++n;
		}
	}
	
	float s = 0.0;
	for (int i=0; i < kSize*kSize; ++i) {s += c[i];}

	
	gl_FragColor = vec4(1.0);
}