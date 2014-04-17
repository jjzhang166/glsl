// fuck that shit.

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 uv = gl_FragCoord.xy;
	
	vec2 O = vec2(cos(time*2.0)*0.3+0.3+0.2,0.5)*resolution.xy;
	float R = (sin(time*2.0)*0.10+0.125)*resolution.x;
	
	float d = distance(uv, O);
	
	float alpha = R-d;
	
	gl_FragColor = vec4(alpha);
}