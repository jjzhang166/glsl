#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 distancetoX = gl_FragCoord.xy / resolution.xy ;
	float xWave = sin(time) * 0.5 + 0.5;
	
	float red = sin(distancetoX.x * time);
	float green = cos(distancetoX.y * time);
	float blue = sin(distancetoX.x * time);
	
	gl_FragColor = vec4(red,0.0,green,blue);
}