// 
// by @hektor41 
// 21/06/12
// v.1


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float f(float x, float y) {
	//x = (mouse.x*10.0)*x; //Interactive
	
	float nx = x + sin(time*9000.0*x);
	float ny = y + cos(time*10.0*y);
	
	float formula = 1.0/( sin( x + sin(time/1000.0)*time ) + y );
	float formula_effects = sqrt(ny);
	
	return formula_effects;
}



void main( void ) {
	
	// CONTROLS
	 float zoom =10.0;
	 float cameraX = 6.0;
	 float cameraY = (zoom*3.0)/10.0-0.5;
	 
	// ^ ^ ^ ^ 
	
	zoom += 0.5;
	vec2 p = ( gl_FragCoord.xy /(resolution.x * 1.0/zoom));
	float x = p.x - cameraX;
	float y = p.y - cameraY;

	float a = f(x,y);
	float c = sqrt(a);
	gl_FragColor = vec4(c/10.0,   c/8.0,  c/5.0,  1.0);

}