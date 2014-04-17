#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

void main( void ) {
	
	vec2 p = gl_FragCoord.xy / resolution.xy;
	float f = length(mouse.xy-p);
	
	vec3 o = cross(vec3(f), vec3(p,f));
	
	o = o/vec3(dot(o, vec3(f)));
	o = o/cross(o,o-f);
	o = o/vec3(dot(o, vec3(f)));
	o = o/cross(o,o-f);
	o = o/vec3(dot(o, vec3(f)));
	o = o/cross(o,o-f);
	o = o/vec3(dot(o, vec3(f)));
	o = o/cross(o,o-f);
	o = o/vec3(dot(o, vec3(f)));
	o = o/cross(o,o-f);
	
	
	
	gl_FragColor = vec4(o,0.0);
}
