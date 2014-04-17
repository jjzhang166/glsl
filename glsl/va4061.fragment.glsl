#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 pos = gl_FragCoord.xy / resolution.xy;
	float dist = distance(gl_FragCoord.xy, resolution.xy * 0.5) / resolution.y;
	vec3 color = vec3(0.0);
	float s = mod(dist-0.009-time*0.02, 0.08);
	if (s > 0.04) {
		color = vec3(248.0/255.0, 182.0/255.0, 26.0/255.0);
		color.bg -= 0.2 * min(pow(sin(s * 32.0 + pos.x * 16.0 - pos.y * 4.0+time) + cos((s-dist)*20.0 + pos.x * sin((dist - s) * 16.0) * 28.0 -sin((dist - s) * 19.0) * pos.y * 4.0 + time) * 2.0, 32.0), 1.0);
		color *= 1.1;
	}
	else {
		color = vec3(16.0/255.0, 128.0/255.0, 195.0/255.0);
		color.r += mod(pos.x*50.0 + 3.0 + sin(pos.y * 50.0) * sin((dist - s) * 45.0), 2.0) > 1.0 ? 0.5 : 0.0;
		color *= 0.9;
	}
	color *=max( 1.0 - max(dist - 0.6, 0.0) * 3000.0, 0.0);
	
	gl_FragColor = vec4(color, 1.0);

}