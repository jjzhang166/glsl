precision lowp float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform vec2 surfaceSize;

void main( void ) {

	vec2 mousePos = mouse * resolution;
	
	// Circle should be 3/4th of the Y resolution
	float flCirclePixels = resolution.y;
	
	float flDistance = distance(mousePos, gl_FragCoord.xy) / flCirclePixels;
	
	gl_FragColor = vec4( flDistance );
}