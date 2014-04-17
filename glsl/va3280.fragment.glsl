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

	vec3 black = vec3 ( 0.0, 0.0, 0.0);
	vec3 myCol = vec3 ( 0.0, 0.0, 0.0);
	//myCol.r += sin(time);
	if (sin(y)+sin(x+sin(time))>cos(time)) { myCol.r = cos(time); myCol +=sin(x); }
	gl_FragColor = vec4(myCol, 1.0);

}