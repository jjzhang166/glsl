// Posted by Trisomie21

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
	float color = nrand(screen_pos*0.01 + time*0.01);
	
	if (length(n) > 4.0)
	{
		vec2 y = normalize(-n);
		vec2 x = vec2(-y.y, y.x);
		
		float d = length(n);
		float r = color*d*.25;
	
		color = texture2D(backbuffer, (screen_pos + y*r*.2)/resolution).z*.5 +
			texture2D(backbuffer, (screen_pos + y*r*.8 - x*r*.9)/resolution).z*.5;
	}
	gl_FragColor = vec4(color-.2, color - .5, color, 1.0 );
}