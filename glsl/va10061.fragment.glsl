#ifdef GL_ES
precision highp float;
#endif

#define PI 3.1415

#define SPEED 1.5

#define BACKGROUND_COLOR vec4(1,1,1,1)

#define PACMAN_SIZE 0.4
#define PACMAN_COLOR vec4(1,1,0,1)
#define PACMAN_EYE_SIZE 0.125
#define PACMAN_EYE_POS -0.15, 0.5
#define PACMAN_EYE_COLOR vec4(0,0,0,1)

#define BALL_SIZE 0.1
#define BALL_DISTANCE 0.3
#define BALL_COLOR vec4(1,1,0,1)

#define BORDER_THICKNESS 0.01
#define BORDER_COLOR vec4(0,0,0,1)

#define LIGHT_POS -0.3

#define BALL_DISAPPEAR_OFFSET (BALL_DISTANCE*0.5-PACMAN_SIZE+BALL_SIZE) // at the start of the mouth
//#define BALL_DISAPPEAR_OFFSET ((BALL_DISTANCE-PACMAN_SIZE)*0.5) // in the middle of the mouth
//#define BALL_DISAPPEAR_OFFSET (BALL_DISTANCE*0.5) // in the center of pacman

//#define MOUSE_CONTROL

uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

vec2 get_pos() {
	vec2 pos = ( gl_FragCoord.xy / resolution.xy ) - vec2(0.5);
	pos.x *= resolution.x / resolution.y;
	return pos;
}

vec2 get_distance_to_line(vec2 pos, vec2 point, float angle) {
	angle = angle/180.0*PI;
	vec2 line_dir = vec2(cos(angle),sin(angle));
	vec2 perp_dir = vec2(line_dir.y, -line_dir.x);
	pos = pos - point;
	return vec2(dot(line_dir, pos), dot(perp_dir, pos));
}

float get_radial_distance(vec2 pos, vec2 center) {
	return length(pos-center);
}

void main( void ) {
	vec2 pos = get_pos();
	
	#ifdef MOUSE_CONTROL
	float t = mouse.x*4.0;
	#else
	float t = time*SPEED;
	#endif
	
	float ang = 0.5*(cos(t*PI)+1.0)*40.0;
		
	float dist_to_center = length(pos);
	float dist_to_eye = get_radial_distance(pos,vec2(PACMAN_EYE_POS)*PACMAN_SIZE);
	float offset = (t+1.0)*(BALL_DISTANCE)*0.5;
	float dist_to_ball = get_radial_distance(vec2(mod(pos.x+offset+BALL_DISAPPEAR_OFFSET, BALL_DISTANCE), pos.y),vec2(BALL_DISTANCE*0.5,0));
	vec2 dist_to_line1 = get_distance_to_line(pos,vec2(0,0), ang);
	vec2 dist_to_line2 = get_distance_to_line(pos,vec2(0,0), -ang);
	    	
	if (dist_to_center > PACMAN_SIZE || dist_to_line1.y > 0.0 && dist_to_line2.y < 0.0)
	{
		if (pos.x < BALL_DISTANCE-BALL_DISAPPEAR_OFFSET-mod(offset, BALL_DISTANCE))
			gl_FragColor = BACKGROUND_COLOR;
		else if (dist_to_ball < BALL_SIZE-BORDER_THICKNESS) 
			gl_FragColor = mix(BALL_COLOR,vec4(0,0,0,1),length(pos+vec2(LIGHT_POS)));
		else if (dist_to_ball < BALL_SIZE)
			gl_FragColor = BORDER_COLOR;
		else
			gl_FragColor = BACKGROUND_COLOR;
	}
	else if (dist_to_line1.y > -BORDER_THICKNESS && dist_to_line1.y < 0.0 && dist_to_line1.x > 0.0)
		gl_FragColor = BORDER_COLOR;
	else if (dist_to_line2.y < BORDER_THICKNESS && dist_to_line2.y > 0.0 && dist_to_line2.x > 0.0)
		gl_FragColor = BORDER_COLOR;
	else if (dist_to_center < BORDER_THICKNESS)
		gl_FragColor = BORDER_COLOR;
	else if (dist_to_eye < PACMAN_EYE_SIZE*PACMAN_SIZE) 
		gl_FragColor = PACMAN_EYE_COLOR;
	else if (dist_to_center < PACMAN_SIZE-BORDER_THICKNESS)
		gl_FragColor = mix(PACMAN_COLOR,vec4(0,0,0,1),length(pos+vec2(LIGHT_POS)));
	else /*if (dist_to_center < PACMAN_SIZE)*/
		gl_FragColor = BORDER_COLOR;
}