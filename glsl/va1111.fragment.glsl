#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 distancetoX = gl_FragCoord.xy / resolution.xy ;
	float xWave = sin(time) * 0.5 + 0.5;
	gl_FragColor = vec4(xyZeroToOne.x*mouse.y,0.0,xyZeroToOne.y*mouse.x,1.0);
}