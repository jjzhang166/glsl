#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float dist = distance(gl_FragCoord.xy, resolution / 2.0);
	dist /= resolution.x;
	vec3 color = vec3(.5,.5,.5);
	if (dist < 0.1)
	  color = smoothstep(1., 0.21, 1.0) * vec3(12.0, 1.0, .11236);
        else
	  color = (0.2 / dist) * vec3(0.2, 0, 1);
	gl_FragColor = vec4(color, 1.0);
}