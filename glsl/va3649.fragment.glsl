// 
// by @hektor41 
// 21/06/12
// v.1
// rotwang: @mod* curve function, shading

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.1415926535;

float f(float x, float y) {
	
	return step(sin(x*PI)+y*y,0.99)*sin(x*PI)-y;
}



void main( void ) {
	
	// CONTROLS
	 float zoom =10.0;
	 float cameraX = 4.0;
	 float cameraY = (zoom*2.0)/8.0-0.5;
	 
	// ^ ^ ^ ^ 
	
	zoom += 0.5;
	vec2 p = ( gl_FragCoord.xy /(resolution.x * 1.0/zoom));
	float x = p.x - cameraX;
	float y = p.y - cameraY;

	float a = f(x,y);
	float b = f(x,y*1.33);
	float m = smoothstep(a*a-b,a*a+b,1.0-sqrt(a*b)); 
	float c = a+b*m*b-b;
	gl_FragColor = vec4(a/2.0,  b/5.0,  c/4.0,  1.0);

}