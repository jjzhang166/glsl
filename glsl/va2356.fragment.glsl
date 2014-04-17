#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float bounce = sin(time);
	
	//vec2 ball = vec2(0.5, (abs(sin(time) * 0.3 * abs(sin(time / 0.2))) + 0.15));
	
	vec3 color = vec3(0.2);
	
	vec2 light = vec2(1.0, 1.0);
	
	vec2 dist = gl_FragCoord.xy;
	vec2 uv = dist / resolution.xy;
	uv.y /= resolution.x / resolution.y;
	
	color += uv.y - 0.2;
	
	// Calc dist
	//float lightdist = length(light - ball) + 0.1;
	
	
	//float len = length(uv - ball);
	/*if (len < 0.1) {
		vec2 highlight = ball + vec2(0.05, 0.05);
		color = vec3(-((length(uv - highlight) * 7.0) - 1.1));	
	}*/
	
	gl_FragColor = vec4(color, 1.0);
}