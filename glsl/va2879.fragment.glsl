// 
// by @hektor41 
// 21/06/12

// doublehelix 


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float f(float x, float y) {
	
	float sinTime = sin(time);
	float sinTimeIter = sin(time*y + 0.1*x*x*sinTime);
	
	float ny = y + 2.0*sin(time*y + 0.1*x*x*sinTime + y + 2.0*sinTimeIter);
	
	float formula = 0.2/( sin( x*1.5 + time + y + 1.0*sinTimeIter ) + 0.05 - y );
	float formula_effects = formula/sqrt(ny*sinTime);
	
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

	float a = sqrt(f(x,y));
	
	gl_FragColor = vec4(a/9.0,  a/6.0,  a/10.0,  1.0);

}