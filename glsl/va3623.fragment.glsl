// 
// by @hektor41 
// 21/06/12
// v.1

//MOD + :)


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;


float f(float x, float y,float z) {
	x+=x+sin(x*1.0);
	y+=y+sin(y*3.0);
	
	return 1.0/( sin( x + time*0.1*z ) * 4. - y ) / cos(time + (y*x)) * 15.;
}



void main( void ) {
	
	// CONTROLS
	 float zoom = (sin(time)/0.2)+10.0; ///50.0;
	 float cameraX = 5.0;
	 float cameraY = (zoom*3.0)/15.0;
	 
	// ^ ^ ^ ^ 
	
	vec2 p = ( gl_FragCoord.xy /(resolution.x * 1.0/zoom));
	float x = p.x - cameraX;
	float y = p.y - cameraY;

	float a = f(x+sin(-time*0.1),y+sin(time*0.55),2.0);
	float b = f(x+sin(-time*1.83),y+sin(time*0.94),1.0);

	gl_FragColor = vec4(a,b,0.0,1.0);
}