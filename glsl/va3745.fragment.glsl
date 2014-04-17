// 
// by @hektor41 
// 21/06/12
// v.1
//
// Modified by @hektor41
// 31/08/12

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float f(float x, float y) {
	//x = mouse.x*x; //Interactive
	
	float nx = x + sin(time*x);
	float ny = y + sin(time*y);
	
	float formula = 1.0/( sin( x + time ) + y );
	
	float formula_effects = formula*asin(time/2.0)-(4.0/formula)*tan(time);
	
	formula_effects = (x*sqrt(x))/atan(formula_effects/x);
	
	return formula_effects;
}



void main( void ) {
	
	// CONTROLS (accurate for a 1920x1080 screen)
	 float zoom = 90.0;
	 float cameraX = (zoom*5.0)/10.0-0.5;
	 float cameraY = (zoom*2.7)/10.0-0.5;
	 
	// ^ ^ ^ ^ 
	
	zoom += 0.5;
	vec2 p = ( gl_FragCoord.xy /(resolution.x * 1.0/zoom));
	float x = p.x - cameraX;
	float y = p.y - cameraY;

	float a = f(x,y);
	float c = sqrt(a);
	gl_FragColor = vec4(c/10.0,   c/8.0,  c/5.0,  1.0);

}