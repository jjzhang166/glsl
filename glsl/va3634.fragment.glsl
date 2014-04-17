// 
// by @hektor41 
// 21/06/12
// v.1

//MOD + :)
//modyfing by 28.room


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;


float f(float x, float y,float z) {
	x+=cos(x*3.0);
	y+=y+atan(y*3.0);
	
	float formula = 5.0/( sin( x + time*0.1*z ) * 12. + y ) / cos(time + (y*x)) * 150.;
	float formula_effects = formula;///sqrt(ny);
	
	return formula_effects;
}



void main( void ) {
	
	 float zoom = 1.0;
	 float cameraZ = 2.5;
	 float cameraY = (zoom*3.0)/10.0-0.5;
	 
	// ^ ^ ^ ^ 
	
	zoom += 10.5;
	vec2 p = ( gl_FragCoord.xy /(resolution.x * 1.0/zoom));
	float x = p.x - cameraZ;
	float y = p.y - cameraY;

	float a = f(x+sin(-time*0.31),y+sin(time*0.55),20.0);
	float b = f(x+sin(-time*0.63),y+sin(time*0.94),10.0);
	float c = f(x+sin(-(time+a*0.1)*0.39),y+sin(time*0.22),10.0);
	
	gl_FragColor = (
			vec4(1,  0.0,  10,  1.0)+
			vec4(100,  0.0,  abs(sqrt(abs(b)))/10.0,  10.0)+
			vec4(10.0,  abs(sqrt(abs(a)))/15.0,  abs(sqrt(abs(c)))/10.0,  10.0)
		)/2.0;

}