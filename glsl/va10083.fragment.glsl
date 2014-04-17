#ifdef GL_ES
precision highp float;
#endif
  
#define PACMAN_RADIUS 0.30
#define PACMAN_BORDER 0.02
 
#define PACMAN_EYE_X - 0.08
#define PACMAN_EYE_Y  0.15
#define PACMAN_EYE_RADIUS 0.03
 
#define PACMAN_COLOR vec4(1,1,0,1)
#define PACMAN_BORDER_COLOR vec4(0,0,0,0)
#define PACMAN_EYE_COLOR vec4(0,0,0,1)
#define PACMAN_BACKGROUND_COLOR  vec4(2,1,3,1) 
#define BALL_COLOR vec4(1,1,0,1)

#define NUMBER_BALLS 10.0
#define BALL_RADIUS 0.03

#define LIGTH_POSITION vec2(-0.3)
 
#define ANIM_SPEED 2.0
 
#define MOUTH_ANGLE 30.0
 
#define PI 3.1415
 
uniform vec2 resolution;
uniform float time;

//--------------------------------------------------------------------------
// Get the current position relative to screen resolution
vec2 get_current_position() {
    vec2 pos = ( gl_FragCoord.xy / resolution.xy ) - vec2(1.0) * 0.5;
    pos.x *= resolution.x / resolution.y;
    return pos;
}
 
//--------------------------------------------------------------------------
// Simplified distance function. 
float get_radial_distance(vec2 pos, vec2 center) {
	return length(pos-center);
}
 
//--------------------------------------------------------------------------
// 
float get_distance_to_line(vec2 pos, vec2 point, float angle) {
    angle = angle/180.0 * PI;
    vec2 another_point = point + vec2(cos(angle),sin(angle));
    vec2 line_dir = another_point - point;
    vec2 perp_dir = vec2(line_dir.y, -line_dir.x);
    vec2 dir_to_point = point - pos;
    return (dot(normalize(perp_dir), dir_to_point));
}

//--------------------------------------------------------------------------
// Draws the balls items to be "eaten" by our hero.
void  draw_ball(float ball_num, vec2 position)
{
	float _ball_pos;			// Ball position
	float _time = fract(time);	// Get the animation speed
	_time *= -1.0;				// In order to make it go from rigth to left
	float _ball_radius_distance;// Distance between the current point and the ball's center
	
	_ball_pos =  0.2 * _time;
	_ball_pos += ball_num * 0.2;// Space between balls
	_ball_radius_distance = get_radial_distance(position,vec2(_ball_pos,0));

	if (_ball_radius_distance < BALL_RADIUS+PACMAN_BORDER/2.0)
	{
		float t = smoothstep(BALL_RADIUS+PACMAN_BORDER/2.0, BALL_RADIUS-PACMAN_BORDER/2.0, _ball_radius_distance);
		gl_FragColor = mix(PACMAN_BACKGROUND_COLOR,mix(PACMAN_COLOR,vec4(0.0,0.0,0.0,1.0),sqrt(dot(position+LIGTH_POSITION,position+LIGTH_POSITION))) ,t);
	}
}
 
void main(void) {
 
	vec4 _color;	
	float _time = time * ANIM_SPEED;	
	
	// Get Current distances for future calculation
	vec2 _curr_pos = get_current_position();	
	float _dist_to_eye = get_radial_distance(_curr_pos,vec2(PACMAN_EYE_X,PACMAN_EYE_Y));		
   	float _dist_to_center = length(_curr_pos);	
	float _mouth_top = get_distance_to_line(_curr_pos,vec2(0,0),abs(MOUTH_ANGLE * sin( _time)));
	float _mouth_bottom = get_distance_to_line(_curr_pos,vec2(0.0,0),abs(MOUTH_ANGLE * sin(_time))*-1.0);

	if (_dist_to_eye < PACMAN_EYE_RADIUS+PACMAN_BORDER)// Eye circle
	{
		float t = smoothstep(PACMAN_EYE_RADIUS+PACMAN_BORDER, PACMAN_EYE_RADIUS-PACMAN_BORDER, _dist_to_eye);
		_color= mix (mix(PACMAN_COLOR,vec4(0.0,0.0,0.0,1.0),sqrt(dot(_curr_pos+LIGTH_POSITION,_curr_pos+LIGTH_POSITION))),PACMAN_EYE_COLOR,t);
	}
	// Mouth
	else if (_mouth_top < 0.0 && _mouth_bottom > 0.0 && _curr_pos.x > 0.0 && _curr_pos.y < 0.5 && _dist_to_center < PACMAN_RADIUS+PACMAN_BORDER*2.0)
		_color= PACMAN_BACKGROUND_COLOR;
		
	else if (_dist_to_center < PACMAN_RADIUS+ PACMAN_BORDER) // Pacman circle
	{
		// Default Pacman color
		_color = mix(PACMAN_COLOR,vec4(0.0,0.0,0.0,1.0),sqrt(dot(_curr_pos+LIGTH_POSITION,_curr_pos+LIGTH_POSITION)));
		
		// Depending if the inner border or the outer borde
		if (_dist_to_center < PACMAN_RADIUS + PACMAN_BORDER && _dist_to_center > PACMAN_RADIUS)
		{
			float t = smoothstep(PACMAN_RADIUS+PACMAN_BORDER, PACMAN_RADIUS, _dist_to_center);
			_color = mix (PACMAN_BACKGROUND_COLOR,PACMAN_BORDER_COLOR,t);
		}		
		else
		{
			float t = smoothstep(PACMAN_RADIUS, PACMAN_RADIUS-PACMAN_BORDER, _dist_to_center);
			_color = mix(PACMAN_BORDER_COLOR,_color,t);
		}
	}
	else // All the background color
		_color= PACMAN_BACKGROUND_COLOR;
	
	// Try to draw the balls on top of everything
	if (_color !=PACMAN_BACKGROUND_COLOR)
	{
		for (float i = 1.0; i < NUMBER_BALLS; i++)
			draw_ball (i,_curr_pos);
		
		gl_FragColor = _color;
	}
	else
	{
		gl_FragColor = _color;
		for (float i = 1.0; i < NUMBER_BALLS; i++)
			draw_ball (i,_curr_pos);		
	}
}