// @rotwang: like it!
// @mod+ zoom per mouse

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float f(float x, float y) {
	float formula = .4/( cos( x + time ) - y );
	return formula;
}


void main( void ) {

	
	
	float zoom =5.0 + 10.0*mouse.x;
	float cameraX = (zoom*2.0)/10.0;
	float cameraY = (zoom*4.0)/10.0-0.5;
 

	zoom += 1.;
	vec2 p = ( gl_FragCoord.xy /(resolution.x * 1.0/zoom));
	float x = p.x - cameraX;
	float y = p.y - cameraY;

	float a = f(x,y);
	vec4 color = vec4(0,0,0,0);
	color.x = (sqrt(a)/10.) * sin(x);
	color.y = (sqrt(a)) * sin(x);
	color.z = (sqrt(a)/15.) * log(time) * sin(x);

	gl_FragColor = color;

}