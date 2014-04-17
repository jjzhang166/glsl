#ifdef GL_ES
precision highp float;
#endif

#define PACMAN_RADIUS 0.35
#define PACMAN_BORDER 0.005
#define PACMAN_EYE_X - 0.08
#define PACMAN_EYE_Y  0.2
#define PACMAN_EYE_RADIUS 0.03
#define MOUTH_SPEED 50.0

uniform vec2 resolution;
uniform float time;


vec2 get_pos() {
    vec2 pos = ( gl_FragCoord.xy / resolution.xy ) - vec2(1.0) * 0.5;
    pos.x *= resolution.x / resolution.y;
    return pos;
}

float get_radial_distance(vec2 pos, vec2 center) {
    vec2 tmp = pos-center;
    return sqrt(dot(tmp,tmp));
}

float get_distance_to_line(vec2 pos, vec2 point, float angle) {
    angle = angle/180.0*3.1415;
    vec2 another_point = point + vec2(cos(angle),sin(angle));
    vec2 line_dir = another_point - point;
    vec2 perp_dir = vec2(line_dir.y, -line_dir.x);
    vec2 dir_to_point = point - pos;
    return (dot(normalize(perp_dir), dir_to_point));
}

float get_mouth_angle(bool is_top)
{
	float temp;
	if (is_top)
	{
		temp = MOUTH_SPEED * sin(time);
		if (temp < 0.0)
			{
				temp *= -1.0;
			}		
	}
	else
	{
		temp = MOUTH_SPEED * sin(time) * -1.0;
		if (temp > 0.0)
		{
			temp *= -1.0;
		}		
	}
	
	return temp;
}

float dist_to_ball(float _ball_num, vec2 _position)
{
	float local_time = mod(time,360.0);
	vec4 color =  vec4(1.0,1.0,0.0,1.0);
	//float sin_time = sin (time);
	
	float sin_time = sin (time);
	
	if ( local_time < 135.0)
	{	
		sin_time  = sin(time);
		color =  vec4(1.0,1.0,0.0,1.0);		
	}
	else 
	{
		sin_time = cos (time);
		color = vec4(1.0,0.7,0.5,1.0);
	}
	
	
	float ball_pos;
	
	if (sin_time < 0.0) 
	{
		sin_time = sin_time * -1.0;	
	}
	
	ball_pos = (0.4 +_ball_num * 0.2)  * sin_time;
	
	
		
	
	float dist_to_ball1 = get_radial_distance(_position,vec2(ball_pos,0));
	
	if (dist_to_ball1 < 0.03)
	{		
		gl_FragColor =color;	 
	}
	
	return dist_to_ball1;
	
}

void main( void ) {

	vec2 pos = get_pos();
   	float dist_to_center = length(pos);
	
	float mouth_top;
	float mouth_bottom;
   
	// Set Background color to black
	gl_FragColor = vec4(0.2,0.0,0.0,0.0);    

	float ball_pos = 0.4 * sin (time);
	//float dist_to_ball1 = get_radial_distance(pos,vec2(ball_pos,0));
//	float dist_to_ball1 = dist_to_ball (1,pos);
    	float dist_to_ball2 = get_radial_distance(pos,vec2(ball_pos+0.2,0));
	float dist_to_ball3 = get_radial_distance(pos,vec2(ball_pos+0.4,0));
	
	//if (dist_to_ball1 < 0.03)// || dist_to_ball2 < 0.03 || dist_to_ball3 < 0.03) 
	//	gl_FragColor = mix(vec4(1.0,1.0,0.0,1.0),vec4(0.0,0.0,0.0,1.0),sqrt(dot(pos+vec2(-0.3),pos+vec2(-0.3))));
	
	
	//***************
	// Draw our hero (PACMAN)	
	// 1. The sphere of our hero + little border
	if (dist_to_center < PACMAN_RADIUS)
	{
		// As we approach the center, draw the 
		gl_FragColor = mix(vec4(1.0,1.0,0.0,1.0),vec4(0.0,0.0,0.0,1.0),sqrt(dot(pos+vec2(-0.3),pos+vec2(-0.3))));
    	
	}
	else if (dist_to_center < PACMAN_RADIUS+PACMAN_BORDER)
	{        
		gl_FragColor = vec4(1,1,0.0,1.0);

	}
	
	float dist_to_eye = get_radial_distance(pos,vec2(PACMAN_EYE_X,PACMAN_EYE_Y));
	
	// 2. Our hero's eye 
	if (dist_to_eye < PACMAN_EYE_RADIUS) 
	{
		gl_FragColor = vec4(0.0,0.0,0.0,1.0);
	}
	
	// 3. Our hero's mouth :)		
	mouth_top = get_distance_to_line(pos,vec2(0,0),get_mouth_angle(true));
	mouth_bottom = get_distance_to_line(pos,vec2(0.0,0),get_mouth_angle(false));
   
	// Check if we are inside the mouth borders to draw it
	if (mouth_top < 0.0 && mouth_bottom > 0.0 && pos.x > 0.0 && pos.y < 0.5 && dist_to_center < 0.36)
	{
		gl_FragColor = vec4(0.0,0.0,0.0,1.0);
	}
	
	//***************
	// Draw some white dots "to be eaten"
	dist_to_ball (1.0,pos);
	//dist_to_ball (2.0,pos);
	//dist_to_ball (3.0,pos);
	
}