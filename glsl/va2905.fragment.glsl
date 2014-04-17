#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {
	vec2 coord = gl_FragCoord.xy / resolution;
	
	float r = sin(time);
	float g = sin(time + 10.0);
	float b = sin(time + 20.0);
	vec3 rgb = vec3(r,g,b);
	
	gl_FragColor = vec4( rgb, 1.0 );
}