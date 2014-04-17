#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
float pulse=sin(time);
float center_dot=smoothstep(1.0, 3.0+pulse, distance(gl_FragCoord.xy, resolution.xy/2.0));
vec3 background=vec3(0.12+0.08*sin(0.13*time),
	0.16+0.08*sin(0.29*time),
	0.18+0.09*sin(0.19*time));
gl_FragColor=vec4(mix(background,vec3(1.0),1.0-center_dot), 1.0);}