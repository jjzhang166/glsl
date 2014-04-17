#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2  O = vec2(.5,.5)*resolution.xy;
float R = .25*resolution.x;

vec2  S = vec2(.15,.15)*resolution.xy;

void main( void ) {

	vec2 uv = gl_FragCoord.xy;
	
	// Circle
	float circle = abs(distance(uv, O)-R);	
	
	// Rectangle
	vec2 D = abs(uv-O) - S;
  	float rectangle = abs(min(max(D.x,D.y), 0.0) + length(max(D, 0.0)));
	
	gl_FragColor = vec4(min(circle, rectangle));
}