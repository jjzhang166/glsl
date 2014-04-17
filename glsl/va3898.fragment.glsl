#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

void main( void ) {
	
	float aspect = resolution.x / resolution.y;
	vec2 unipos = gl_FragCoord.xy / resolution;
	vec2 pos = unipos*2.0-1.0;
	pos.x *= aspect;

	vec2 ap = abs(pos);
	vec2 v = vec2(0.5);
	

	float shade = distance(ap,v);
	vec3 clr = vec3(shade);
	
	gl_FragColor = vec4(clr, 1.0);

}