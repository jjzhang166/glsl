// @hektor41 
// 20/06/12
// v.2
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float sqr(float n) { return n*n;}


float move(float x, float y, float fx, float fy) {
	float nx = x + cos(time*fx);
	float ny = y / tan(time*fy)/sqrt(cos(y));
	

	return sqrt(1.0/sqrt(nx*nx*nx + nx*ny - nx - ny));
}



void main( void ) {
	
	// CONTROLS
	 float zoom =100.0;
	 
	// ^ ^ ^ ^ 
	
	zoom += 0.5;
	vec2 p = ( gl_FragCoord.xy /(resolution.x * 1.0/zoom));
	float x = p.x;
	float y = p.y;

	float a = move(x-40.0,y-40.0,2.0,4.0);
	float b = move(x-20.0,y-20.0,10.0,-2.0);
	float c = move(x-80.0,y-50.0,9.0,-8.0);
	
	gl_FragColor = vec4(sqrt(a),sqrt(b),sqrt(c),1.0);

}