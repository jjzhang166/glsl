#ifdef GL_ES
precision mediump float;
#endif

uniform float time;

float rand(vec2 co)
{
	return fract(sin((co.x+co.y*1e3)*1e-3) * 1e5);
}

void main(void)
{
	float r;
	float ofs = fract(time);

	r = rand(gl_FragCoord.xy+vec2(0.0,0.9*ofs));
	
	gl_FragColor = vec4(r, r, r, 1.0);
}