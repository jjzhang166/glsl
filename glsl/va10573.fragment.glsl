//by Hosson (2013.8.21)

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int Num = 8;

void main( void ) {
	vec2 CPos[Num];
	for (int i = 0; i < Num; i++)
	{
		float Phi = (float(i) / float(Num)) * 6.28;
		Phi += atan(mouse.y - 0.5, mouse.x - 0.5) * 1.0;
		CPos[i] = vec2(0.5 + cos(Phi) * 0.3, 0.5 + sin(Phi) * 0.3);
	}
	
	vec2 pos = ( gl_FragCoord.xy / resolution.xy );

	float R[Num], G[Num], B[Num];
	float cr = 0.0, cg = 1.0, cb = 2.0;
	for (int i = 0; i < Num; i++)
	{
		float tp = mod(time, 2.0);
		if (tp > 1.0)
			tp = 1.0 - (tp - 1.0);
		
		cr += 0.2;
		cg += 0.2;
		cb += 0.2;
		float cr2 = cr + tp;
		float cg2 = cg + tp;
		float cb2 = cb + tp;
		if (cr2 > 2.0)
			cr2 = 2.0 - (cr2 - 2.0);
		if (cg > 2.0)
			cg2 = 2.0 - (cg2 - 2.0);
		if (cb > 2.0)
			cb2 = 2.0 - (cb2 - 2.0);
		R[i] = cr2;
		G[i] = cg2;
		B[i] = cb2;
	}
	
	vec3 color;
	for (int i = 0; i < Num; i++)
	{
		float col = 0.0;
		col = col + max(0.1 - distance(pos, CPos[i]), 0.0) * 10.0;
		col = clamp(col, 0.0, 1.0);
		color = color + vec3(col * R[i] * 0.5, col * G[i] * 0.5, col * B[i] * 0.5);
	}

	gl_FragColor = vec4(color, 1.0 );

}