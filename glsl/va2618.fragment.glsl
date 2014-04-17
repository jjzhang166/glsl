#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	vec2 m = mouse;
	vec2 res = resolution;
	vec2 op = vec2(gl_FragCoord.x,gl_FragCoord.y);
		
	float r = sin(time);
	float g = sin(time + 10.0);
	float b = sin(time + 20.0);
	vec3 rgb = vec3(r,g,b);
	rgb *= sin(time) * sin(time);
	
	gl_FragColor = vec4( rgb, 0.5 );

}