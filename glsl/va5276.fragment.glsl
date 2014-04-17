// Posted by Trisomie21
// forked as explosive 
// "Sucky" bomb mod
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float nrand(vec2 n)
{
	return fract(sin(dot(n.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void main( void ) {

	vec2 screen_pos = gl_FragCoord.xy;
	vec2 mouse_pos = resolution*.5;
	
	vec2 n = screen_pos - mouse_pos;
	float color = nrand(screen_pos*0.01 + time*0.01)*(sin(time*0.75)*100.5);
	
	if (length(n) > 84.0)
	{
		vec2 y = normalize(-n);
		vec2 x = vec2(-y.y, y.x);
		
		float d = length(n*0.75);
		float r = color*d*.015;
	
		color = texture2D(backbuffer, (screen_pos + y*r*.72)/resolution).z*1.15 -
			texture2D(backbuffer, (screen_pos + y*r*.98 - x*r*.9)/resolution).z*.5;
	}
	gl_FragColor = vec4(color-.2, color - .75, color, 1.0 );
}