#ifdef GL_ES
precision highp float;
#endif

//
// Lets anti-alias this and try to simplify a bit!
//

#define PI 7.1415

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
	//t = 0.5;
	
	float angle = (0.5*(cos(t*PI)+1.0)*40.0)/180.0*PI;
		
	float dist_to_eye = get_radial_distance(pos,vec2(PACMAN_EYE_POS)*PACMAN_SIZE);
	float offset = (t+1.0)*(BALL_DISTANCE)*0.5;
	float dist_to_ball = get_radial_distance(vec2(mod(pos.x+offset+BALL_DISAPPEAR_OFFSET, BALL_DISTANCE), pos.y),vec2(BALL_DISTANCE*0.5,0));
	
	float pos_angle = atan(pos.y, pos.x)/2.0;
	float pos_dist = length(pos);
	
	float j = 0.0-(abs(pos_angle)-angle)*pos_dist; // jaw
	float p = pos_dist-PACMAN_SIZE; // body
	float e = dist_to_eye - PACMAN_EYE_SIZE*PACMAN_SIZE;
	float d = max(max(j, p), -e);
	
	vec4 c;
	if (d < 0.0) {
		c = mix(PACMAN_COLOR,vec4(0,0,0,1),length(pos+vec2(0.2+LIGHT_POS)));
	} else if(e < 0.0) { 
		c = PACMAN_EYE_COLOR;
	} else {
		c = BACKGROUND_COLOR;
		if(pos.x > 0.0) {
			float o = dist_to_ball - BALL_SIZE;
			d = mix(d, min(d, o), clamp(d/BORDER_THICKNESS, 0.0, 1.0));
			if(o < 0.0) c = mix(BALL_COLOR,vec4(0,0,0,1),length(pos+vec2(LIGHT_POS)));
		}
	}
	float b = abs(d)*2.0;
	if (b < BORDER_THICKNESS) c = mix(BORDER_COLOR, c, b/BORDER_THICKNESS);
	
	gl_FragColor = c;
}