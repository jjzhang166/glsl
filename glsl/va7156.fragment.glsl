#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void )
{
	vec2 light_pos = vec2((-cos(time)+1.)/2.,(sin(time)/2.0)+0.05) * resolution;

	float intensity = 100.0 * clamp(sin(time),0.1,1.0);
	float dist = distance(gl_FragCoord.xy, light_pos);

	vec3 light_color = vec3(.6, .5, .4);
	float alpha = .5 / (dist/intensity);

	vec4 final_color = vec4(light_color, alpha);
	gl_FragColor = final_color * alpha;
}