#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float dist = distance(gl_FragCoord.xy, resolution / 2.0);
	dist /= resolution.x;
	vec3 color = vec3(.1,.1,.1);
	if (dist < 0.14)
	  color = smoothstep(0., 0.1, 1.0) * vec3(1.0, 1.0, .6);
        else
	  color = (0.2 / dist) * vec3(0.6, 1.4, 1.4);
	gl_FragColor = vec4(color, 1.0);
}