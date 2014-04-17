#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void)
{
	vec2 pos = gl_FragCoord.xy / resolution - vec2(0.5);
	pos.x *= resolution.x / resolution.y;
	float dist = length(pos) * 500.0 * (mouse.x);
	float g = pow(dist/6.0, 6.0) / 2.0;
	
	float shade = ((cos(g + time*2.0)*4.0 ) );
	shade *= sin(g+time);
	vec3 clr = vec3(shade, shade*0.66, shade*0.2);
	gl_FragColor = vec4(clr,1.0);
}