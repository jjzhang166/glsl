#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 uv = gl_FragCoord.xy / resolution.xy * 2.0 - 1.0;
	uv.y += (sin(uv.x*3.) * cos(time*2.0));
	vec3 col = vec3(0.0, 0.0, 0.0);
	col = (abs(uv.y*2.0) >= 1.0) ? vec3(1.0, 1.0, 1.0) : vec3(0.0, 0.0, 1.0);
	if (abs(uv.y) >= 1.0)
		col = vec3(1.0, 0.0, 0.0);
	gl_FragColor = vec4(col, 1.0);
}