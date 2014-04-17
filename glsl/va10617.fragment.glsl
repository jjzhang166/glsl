#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float Cross(vec2 v1, vec2 v2)
{
	return v1.x * v2.y - v2.x * v1.y;
}

float getMax(float v1, float v2, float v3)
{
	if (v1 > v2 && v1 > v3)
		return v1;
	if (v2 > v1 && v2 > v3)
		return v2;
	return v3;
}

void main( void ) {
	vec2 pos = ( gl_FragCoord.xy / resolution.xy );
	
	vec2 Vt[3];
	Vt[0] = vec2(0.3, 0.2);
	Vt[1] = vec2(0.5, 0.8);
	Vt[2] = vec2(0.7, 0.5);

	bool Draw = true;
	float H[3];
	for (int i = 0; i < 3; i++)
	{
		if (i == 2)
			H[i] = Cross(normalize(Vt[0] - Vt[i]), pos - Vt[i]);
		else
			H[i] = Cross(normalize(Vt[i + 1] - Vt[i]), pos - Vt[i]);

		if (H[i] > 0.0)
		{
			Draw = false;
			break;
		}
	}
	
	float c;
	vec3 Color;
	if (Draw == true)
	{
		c = 0.5;
		Color = vec3(0.3, 0.2, c + mod(time, 1.0) * 0.5);
	} else {
		c = getMax(H[0], H[1], H[2]) * 5.0;
		Color = vec3(0.0, 0.0, c);
	}

	gl_FragColor = vec4(Color, 1.0 );

}