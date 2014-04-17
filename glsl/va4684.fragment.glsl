#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 position = gl_FragCoord.xy;//position of pixel
	vec2 newmouse = mouse.xy*resolution.xy;//position of mouse to resolution's size
	vec4 color = vec4(0,0,0,1);//base color
	float dif_x = abs(position.x-newmouse.x);//distance x
	float dif_y = abs(position.y-newmouse.y);//distance y
	float maxdistance = abs(sin(time))*100.0;
	if (pow( pow(dif_x,2.0) + pow(dif_y,2.0) , 0.5) < maxdistance ) {;//total calculated distance with obvious Pythagoras
		color = vec4(1,1,1,1);//colour!
	}
	
	gl_FragColor = color;
}