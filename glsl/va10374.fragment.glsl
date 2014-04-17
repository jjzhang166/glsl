#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float dist = distance(gl_FragCoord.xy, resolution / 2.0);
	dist /= resolution.x;
	vec3 color = vec3(0.5,0.8,0.1);
	if (dist < 0.04)
	  color = smoothstep(0., 0.7, 1.0) * vec3(2.0, 2.0, 1.0);
        else
	  color = (0.1 / dist) * vec3(0.5, 1.7, 1.2);
	gl_FragColor = vec4(color, 1.0);
}