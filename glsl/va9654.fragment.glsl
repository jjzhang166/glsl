#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//following along
//http://lodev.org/cgtutor/juliamandelbrot.html

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	vec3 color = vec3(0.0,0.0,0.0);
	float x = gl_FragCoord.x;
	float y = gl_FragCoord.y;
	float w = resolution.x;
	float h = resolution.y;
	float zoom = 0.5 +mouse.x * 2.0;
	float moveX = 0.24;// mouse.x;
	float moveY = 0.2; mouse.y;
	
	float cRe = -0.7;
   	float cIm = 0.25015 + time*0.001 + mouse.y*0.1;
	float oldRe,oldIm,newRe,newIm;
	newRe = 1.5 * (x - w / 2.0) / (0.5 * zoom * w) + moveX;
        newIm = (y - h / 2.0) / (0.5 * zoom * h) + moveY;
	
	int its;
	for(int i = 0; i < 200; i++){
		its = i;
	 	oldRe = newRe;
	 	oldIm = newIm;
	 	newRe = oldRe * oldRe - oldIm * oldIm + cRe;
	 	newIm = 2.0 * oldRe * oldIm + cIm;
	 	if((newRe * newRe + newIm * newIm) > 4.0) break;
        }
	
        color.x =  float(its)/200.0;
	color.y = float(its)/100.0;
	color.z = 0.0;

	gl_FragColor = vec4( color, 1.0 );

}