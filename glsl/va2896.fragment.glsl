// 
// by @hektor41 
// 21/06/12
// v.1
// messed around with by @danbri, colours etc

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float f(float x, float y) {
	//x = (mouse.x*10.0)*x; //Interactive
	
	float nx = x + cos(time*x) ;
	float ny = y + sin(time*y );
	
	float formula = 1.0/( sin( x + time +(2.*cos(time)) ) - y * sin(time) - sin(time/sqrt(time+ny*nx)) -tan(sqrt(mouse.x)) );
	float formula_effects = formula/sqrt(ny);
	
	return formula_effects;
}



void main( void ) {
	
	// CONTROLS
	 float zoom =10.0;
	 float cameraX = (zoom*5.0)/10.0;
	 float cameraY = (zoom*3.0)/10.0-0.5;
	 
	// ^ ^ ^ ^ 
	
	zoom += 0.5;
	vec2 p = ( gl_FragCoord.xy /(resolution.x * 1.0/zoom));
	float x = p.x - cameraX;
	float y = p.y - cameraY;

	float a = f(x,y);
	
	gl_FragColor = vec4(sqrt(a+(3.5*(sin(time))))/10.0 * sqrt( x * cos(time*x)),  sqrt(a)/8.0 * sqrt(y + (sin(time)* tan(time  * .01))),  sqrt(a)/9.0 * sqrt(cos(time * 10.)+y + sin(time*y)),  1.0);

}