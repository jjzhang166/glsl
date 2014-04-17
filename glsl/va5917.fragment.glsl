#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void )
{
	vec2 light_pos = mouse * resolution;

	float intensity = 35.0;
	float dist = distance(gl_FragCoord.xy, light_pos);

	vec3 light_color = vec3(.6, 1.2, .4);
	float alpha = .5 / (dist/intensity);

	vec4 final_color = vec4(light_color, alpha);
	gl_FragColor = final_color * alpha;
}