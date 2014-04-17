#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	vec2 pos = gl_FragCoord.xy / resolution.xy;
	vec2 m = mouse.xy - vec2(0.025,0.05);
	pos.x *= resolution.x / resolution.y;
	m.x *= resolution.x / resolution.y;
	vec2 square;
	vec3 color;
	
	pos.x = floor(float(pos.x) / 0.1) * 0.1;
	pos.y = floor(float(pos.y) / 0.1) * 0.1;
	

	color.r = distance(pos.xy + vec2(0.3,0.3) , m.xy) * 2.0;
	color.g = distance(pos.xy + vec2(-0.3,0.3) , m.xy) * 2.0;
	color.b = distance(pos.xy + vec2(0,-0.3) , m.xy) * 2.0;
	
	
	//color.b = 1.0 - color.r;
	
	//color = vec3(square, 0);	
	gl_FragColor = vec4(color,0);
} 