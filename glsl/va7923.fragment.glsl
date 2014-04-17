// LOOOOL Test-shader. 4 fun. 

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

float box(in vec2 a, in vec2 b, in vec2 uv) {
	float c;
	
	if(uv.x > a.x && uv.x < b.x
	   && uv.y > a.y && uv.y < b.y)
		c = 1.0;
	else
		c = 0.0;
	
	return c;
}

void main(void)
{
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	uv = uv * vec2( resolution.x / resolution.y, 1.0);

	float s1 = distance(uv, 
						vec2(
							1.0 + (0.10 * sin(time)), 
							0.5 + (0.01 * sin(3.0 * time + 0.5))
						)
					   );
	float s2 = smoothstep(1.0, 0.0, s1);
	
	float b1 = box(vec2(0.20, 0.15), vec2(0.80, 0.40), uv);
	float b2 = box(vec2(0.20, 1.0 - 0.40), vec2(0.80, 0.85), uv);
	
	float c = max(b2, max(b1, s2));
	float c2 = mix(c, s2, s1);
	
	gl_FragColor = vec4(c2,0,0,0);
}
