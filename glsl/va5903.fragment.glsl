#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 mouse;
uniform vec2 resolution;

void main(){
	float dist = sqrt(gl_FragCoord.x*gl_FragCoord.x + gl_FragCoord.y*gl_FragCoord.y);
	gl_FragColor = vec4(dist, dist, dist,1.0);
}