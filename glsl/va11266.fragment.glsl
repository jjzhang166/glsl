#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 pos = (gl_FragCoord.xy - (resolution * 0.5)) / min(resolution.y,resolution.x) * 2.0;
	vec3 color;
	
	if(length(pos) < mod(time * 0.1, 1.0)) color.r = 1.0;
	
	gl_FragColor = vec4(color, 100);

}