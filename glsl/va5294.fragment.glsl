#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main()
{
	float width = 5.0;
	
	vec2 coord = gl_FragCoord.xy + vec2(cos(gl_FragCoord.x ) * 5.0, sin(gl_FragCoord.y) * 5.0);
	//coord.x /= resolution.x / resolution.y;
	
	vec2 coord_center =  gl_FragCoord.xy + vec2( 5.0,  5.0);
	//coord_center.x /= resolution.x / resolution.y;
	
	vec2 a = vec2(abs(sin(time)), 1.0);
	vec2 b = vec2(0.0);
	
	vec2 p = coord;
	
	float len = length(b - a);
	float dist = abs((p.x - a.x) * (b.y - a.y) - (p.y - a.y) * (b.x - a.x)) / len;
	
	vec3 col = vec3(1.0, 8.0, 2.0);
	dist = length(coord - coord_center) * 2.0;
	col /= dist;
	
	gl_FragColor = vec4(col, 1.0);
}