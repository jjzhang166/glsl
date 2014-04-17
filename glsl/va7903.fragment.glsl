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


float f(float x, float y) 
{
	//x = (mouse.x*10.0)*x; 
	x =time*0.001*x;
	return 0.2/( cos( x*x));
}


void main( void ) {
	
	// CONTROLS
	 float zoom =30.0;
	 
	// ^ ^ ^ ^ 
	
	zoom += 0.5;
	vec2 p = ( gl_FragCoord.xy /(resolution.x * 1.0/zoom));
	float x = p.x ;//- cameraX;
	float y = p.y ;//- cameraY;

	float a = f(x,y)/50.0;
	
	gl_FragColor = vec4(sqrt(a),  sqrt(a),  sqrt(a)*2.0,  1.0);

}