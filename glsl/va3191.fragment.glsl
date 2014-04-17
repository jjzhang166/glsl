#ifdef GL_ES
precision mediump float;
#endif
//gt
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float px = gl_FragCoord.x/resolution.x;
	float py = gl_FragCoord.y/resolution.y;
	float x = mod(px*resolution.x,resolution.x/25.);
	float y = mod(py*resolution.y,resolution.y/15.);
	float v =  (x / y)-.7;
	gl_FragColor = vec4(.3-v,.1-v,v-1.,1.0);
}