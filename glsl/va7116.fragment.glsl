#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

void main() {
float WZBallRadius = resolution.y * .23; vec2 WZBPosition = resolution / 2.0; float WZQLength = length(WZBPosition - gl_FragCoord.xy);
	
float QW_RED = cos(gl_FragCoord.x / WZQLength); float QW_GREEN = sin(gl_FragCoord.y / WZQLength); float QW_BLUE = sin(gl_FragCoord.x / WZQLength); QW_RED *= cos(time) / sin(time) / QW_GREEN; QW_GREEN *= sin(QW_RED) / QW_BLUE; QW_BLUE *= cos(QW_GREEN) / sin(time) ;
gl_FragColor = vec4(QW_RED - sin(gl_FragCoord.y * gl_FragCoord.x), QW_GREEN, QW_BLUE, 1.0);
	
 	
}