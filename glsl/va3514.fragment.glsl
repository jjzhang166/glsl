#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

float noise; //little noise variable we create relative to time to give Pacman his famous oral skills.

/**Draws circles.
@radius: the given radius for the circle.
@position: the relative position desired for the circle's center with the center of the screen.
@color: the color for the circle.
@angle: because pacman has a mouth :)
*/
void drawCircle(float radius, vec2 position, vec4 color, float angle){
	
	vec2 current_fragment = vec2(gl_FragCoord.x + position.x,gl_FragCoord.y + position.y);
	
	vec2 horizontal = normalize(vec2(resolution.x, (resolution.y / 2.0)));
	
	vec2 orientacion = normalize(current_fragment - (resolution.xy / 2.0));
	
	float current_angle = acos(dot(horizontal, orientacion));
	
	if((distance(current_fragment, resolution.xy / 2.0) < radius) && current_angle > angle)
		gl_FragColor = color;
}

void drawBody(){
	
	drawCircle(100.0, vec2(0.0, 0.0), vec4(1.0, 0.80, 0.0, 1), 0.75 + (noise / 8.0));
	
}

void drawEye(){
	
	drawCircle(10.0, vec2(0.0 + noise, -60.0), vec4(1.0), 0.0);
	
}

void drawPupil(){
	
	drawCircle(4.0,vec2(-4.0 + noise,-60.0),vec4(0.0),0.0);
	
}

void main( void ) {
	
	noise = -2.35 * sin(time * 14.0); //magic numbers and some random tweking that soften the animation.
	//we draw them in order so Pacman's bodyparts won't overlap themselves.
	drawBody();
	drawEye();
	drawPupil();
	
	//THE END.
	
}