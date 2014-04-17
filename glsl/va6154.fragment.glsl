// by tirinox

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

float shape(vec2 p)
{
	if(p.x>0.8 || p.x < 0.2 || p.y < 0.2 || p.y > 0.8 || p.x * 2.0 - 1.0 > p.y)
		return 0.0;
	
	return 1.0;
}

void main(void) {
	//our final colour
	vec4 vColor = vec4(0.4, 0.2, 0.7, 1.0);
	vec2 pos = vec2(gl_FragCoord.x/resolution.x, gl_FragCoord.y/resolution.y);
	float a = shape(pos);
	gl_FragColor = a * vColor;
}