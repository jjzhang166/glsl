#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//by Mac70

void main( void ) {

	float cycle = mod(time, 10.0)/5.0;
	
	if (cycle>1.0) {
		cycle = 2.0-cycle;
	}
	float coordX;
	float coordY;
	if ((resolution.x/2.0)>=gl_FragCoord.x && (resolution.y/2.0)>=gl_FragCoord.y) {
		coordX = gl_FragCoord.x;
		coordY = gl_FragCoord.y;
	}
	else if ((resolution.x/2.0)<=gl_FragCoord.x && (resolution.y/2.0)>=gl_FragCoord.y) {
		coordX = resolution.x - gl_FragCoord.x;
		coordY = gl_FragCoord.y;
	}
	else if ((resolution.x/2.0)>=gl_FragCoord.x && (resolution.y/2.0)<=gl_FragCoord.y) {
		coordX = gl_FragCoord.x;
		coordY = resolution.y - gl_FragCoord.y;
	}
	else if ((resolution.x/2.0)<=gl_FragCoord.x && (resolution.y/2.0)<=gl_FragCoord.y) {
		coordX = resolution.x - gl_FragCoord.x;
		coordY = resolution.y - gl_FragCoord.y;
	}
	
	float colorX;
	float colorY;
	colorX = min(resolution.x, coordX);
	colorY = min(resolution.y, coordY);
	float colorCombined = min(colorX, colorY);
	float colorSelect = min(resolution.x, resolution.y);
	gl_FragColor = vec4(0, colorCombined/colorSelect*cycle, 0, 1);

}