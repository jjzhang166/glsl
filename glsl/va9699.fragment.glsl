#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2  O = vec2(.5,.5) * resolution.xy;

vec2  S = vec2(.1,.1) * resolution.xy;
float Thickness = 10.0;

void main( void ) {

	vec2 uv = gl_FragCoord.xy;
			
	// Rectangle
	vec2 D = abs(uv - O) - S;
	float Horizontal_Lines = abs(min(D.y + 0.9, - Thickness)) + length(max(D, 0.0)) - Thickness;
	if (Horizontal_Lines <= 0.0) {
		gl_FragColor = vec4(1,0,0,0);
		return;
	}
	
	
	//float Vertical_Lines = abs(min(D.x, - Thickness)) + length(max(D, 0.5)) - Thickness;
	
	gl_FragColor = vec4(Horizontal_Lines/200.);
	//gl_FragColor = vec4(min(Horizontal_Lines, Vertical_Lines));
}