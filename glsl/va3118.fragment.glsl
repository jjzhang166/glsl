#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
uniform vec2 resolution;
void main(void) 
{
	vec2  p = gl_FragCoord.xy / resolution.xy - vec2(0.5, 0.5);
	p.y *= resolution.y / resolution.x;
	float col = 1.0;
	col  = clamp((length(p+vec2(+0.00, +0)) - 0.11) * 1000.0, 0.0, 1.0);
	col *= clamp((length(p+vec2(+0.18, -0)) - 0.11) * 1000.0, 0.0, 1.0);
	col *= clamp((length(p+vec2(-0.18, -0)) - 0.11) * 1000.0, 0.0, 1.0);
	//float k = (1.0 - sin(time) );
	float k=0.0;
	gl_FragColor = vec4(col + k, col - k, col - k, 1.0);
}