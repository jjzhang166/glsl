// @author germangb

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float seed = 1.0;
float random () {
	seed = mod((13821.0 * seed), 32768.0);
	return mod(seed, 2.0)+1.0;
}

void main( void ) {

	vec2 pixel_pos = gl_FragCoord.xy;
	vec3 color1 = vec3(0.7, 0.25, 2.25*sin(time));
	vec3 color2 = vec3(0.25, 0.7, 0.5*cos(time));
	vec3 color3 = vec3(0.5*sin(time), 0.25, 0.7);
	
	vec3 final_color = vec3(0.05*cos(time), 0.025*cos(time*0.5), 0.05*sin(time));

	gl_FragColor = vec4(final_color * abs(sin(time * 0.25) + 1.5)*mod(gl_FragCoord.y, 2.0)*mod(gl_FragCoord.x, 2.0), 1);
}