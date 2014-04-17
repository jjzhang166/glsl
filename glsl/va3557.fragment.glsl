// 
// by @hektor41 
// 21/06/12
// v.1
// rotwang: @mod+ nice relief look, moving/fading lines

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float f(float x, float y) {

	
	float formula = 1.0/( sin( x + sin(time/100.0)*time ) + y );
	float formula_effects = formula; ///sqrt(ny);
	
	return formula_effects;
}



void main( void ) {
	
	// CONTROLS
	 float zoom =20.0;
	 float cameraX = 6.0;
	 float cameraY = (zoom*3.0)/10.0-0.5;
	 
	// ^ ^ ^ ^ 
	
	zoom += 0.5;
	vec2 p = ( gl_FragCoord.xy /(resolution.x * 1.0/zoom));
	float x = p.x - cameraX;
	float y = p.y - cameraY;

	float a = f(x,y);
	float b = p.y* 0.5;
	b = pow(b, 2.0)+f(0.0,x*x*2.0)*4.0;
	float c = sqrt(a+b);
	gl_FragColor = vec4(c/10.0,   c/8.0,  c/5.0,  1.0);

}