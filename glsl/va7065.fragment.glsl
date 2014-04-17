
precision mediump float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float re = position.x;
	float im = position.y;
	
	float startre = re;
	float startim = im;
	const float kOuterBound = 10.0;
	int p;
	for (int i = 0; i < 30; i++)
	{
		
		float re2 = re*re - im*im;
		float im2 = re*im + im*re;
		
		re2 += sin(time) * mouse.x;
		im2 += cos(time) * mouse.y;
		
		re = re2;
		im = im2;
			
		if (re2 > kOuterBound){ break;}
		p = i;
	}

	float j = float(p);
	float r = sin(j * 0.4);
	float g = cos(j * 0.1);
	float b = sin(1.0 * j * 1.2 + 1.0);
	vec4 color = vec4(r,g,b,1.0);
	
	gl_FragColor = color;
}