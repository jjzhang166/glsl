#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void )
{
	vec2 light_pos = resolution / 2.0 + resolution * vec2(sin(time) * 0.3,cos(time)*0.5);

	float intensity = 100.0 * abs(sin((time + 2.0) / 10.0));
	float dist = distance(gl_FragCoord.xy, light_pos);

	vec3 light_color = vec3(.1, .8, .5);
	float alpha = .5 / (dist/intensity);

	vec4 final_color = vec4(light_color, alpha);
	gl_FragColor = final_color * alpha;
}