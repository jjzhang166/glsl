// fuck that shit.

// CBS
// ported from https://www.shadertoy.com/view/lslGWr
// Added some stars: Thanks to http://glsl.heroku.com/e#6904.0

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main() {
	vec2 uv = 1.0 * gl_FragCoord.xy / resolution.xy - 1.0;
	vec2 uvs = uv * resolution.xy / max(resolution.x, resolution.y);
	vec4 color = vec4 (0.0,0.0,0.0,1.0);
	
	float x,y,m,cx,cy;
	x = uvs.x + 0.5;
	y = uvs.y + 0.35;
	x *= sin(time*0.1);
	y *= sin(time*0.1);
	cx = mouse.x + time;
	cy = mouse.y + time;
	
	x=abs(x);
	y=abs(y);
	m=x*x+y*y;
	x=x/m+cx;
	y=y/m+cy;
	
	color.x = abs(sin(x));
	color.y = abs(cos(y));
	color.z = abs(sin(m));
	
	gl_FragColor = color;
	
}