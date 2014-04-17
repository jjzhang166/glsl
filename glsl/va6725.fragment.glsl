#ifdef GL_ES
precision mediump float;
#endif

uniform float time;

float rand(vec2 co)
{
	return fract(sin((co.x+co.y*1e3)*1e-3) * 1e7);
}

void main(void)
{
	float r, g, b;
	float ofs = fract(time);

	r = rand(gl_FragCoord.xy+vec2(0.01*ofs,0.91*ofs));
	g = rand(gl_FragCoord.xy+vec2(0.02*ofs,0.92*ofs));
	b = rand(gl_FragCoord.xy+vec2(0.03*ofs,0.93*ofs));
	
	gl_FragColor = vec4(r, g, b, 1.0);
}