#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float PI = 3.141;

// not quite what I expected from the backbuffer..


void main( void ) {

	vec2 p = vec2(gl_FragCoord.xy / resolution.xy);
	float y4 = 0.1-(cos(p.x+mouse.x+time*0.25)*cos(mouse.y+p.x*PI*2.5*(1.0+sin(time*0.15)))*sin(p.x*PI*(mouse.x+cos(time*0.35)*0.15)*35.0)+2.0)*0.25;
	vec4 col = vec4(vec3(1.0 - smoothstep(0.5, resolution.y * 2.0 * mouse.y, resolution.y*(p.y - y4))), 1.0);
	vec4 altcol = vec4(0.9 + 0.1*sin(0.1*time), 0.9+0.1*sin(0.13*time), 0.9+0.1*sin(0.17*time), 1.0);
	col += altcol * texture2D(backbuffer, vec2(p.x+1.0*(cos(time*1.25))/resolution.x, p.y+1.15/resolution.y));
	if (p.y > 0.998) {
		col = vec4(0.0, 0.0, 0.0, 1.0);	
	}
	gl_FragColor = col;
}