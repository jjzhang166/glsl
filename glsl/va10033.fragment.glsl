#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

#define PI acos(1.0)

void main( void ) {
	

	float l = length(gl_FragCoord.xy - mouse.xy * resolution.xy);
	vec2 waves = normalize(vec2(sin(l) / 2.0, cos(l) / 2.0)) * 2.0;
	vec2 pos = (gl_FragCoord.xy + waves) / resolution.xy;
	vec3 col = texture2D(backbuffer, mod(pos, 1.0)).rgb;
	
	
	float dist = distance(gl_FragCoord.xy, mouse.xy * resolution.xy);
	
	if (mod(dist + 5.0, 10.0) < 5.0 && dist < 50.0)
		col = vec3(abs(mod(time / 10.0, 2.0) - 1.0), abs(mod(time / 1.0, 2.0) - 1.0), abs(mod(time / 20.0, 2.0) - 1.0));
	
	gl_FragColor = vec4(col, 1.0);

}