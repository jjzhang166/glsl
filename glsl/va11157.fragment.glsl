#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = gl_FragCoord.xy / resolution.xy;

	vec3 color = vec3(0);
	
	float val = tan(sin(p.y*p.x*1e6+time));
	if (val > .3) color = vec3(.6);
	
	gl_FragColor = vec4( color, 1.0 );

}