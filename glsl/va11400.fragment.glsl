#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 position = gl_FragCoord.xy;
	float color;
	vec2 lightpos = gl_FragCoord.xy * sin(cos(time / 2.0));
	
	vec2 norm = lightpos - position;
	float sdist = norm.x * norm.x + norm.y * norm.y;
	
	vec3 light_color = vec3(lightpos, 0.9);
	
	color = 1.0 / (sdist * 0.003);

	gl_FragColor = vec4(color,color,color,1.0)*vec4(light_color,1.0);

}