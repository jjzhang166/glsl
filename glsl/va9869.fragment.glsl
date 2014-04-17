#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float Pi      = 3.14159265;
const float Epsilon = 0.001;

const vec3 background_tint = vec3(0.3, 0.1, 0.1);
const vec3 floor_tint      = vec3(0.6, 0.6, 0.8);
	
float compute_floor_distance( const in vec3 position_current )
{
	float distance_traversed = position_current.y + 10.0;
	return distance_traversed;
}

float compute_objects_distance( const in vec3 position_current )
{
	return compute_floor_distance( position_current );
}

vec3 compute_objects_normal(
	const in  vec3  position_current,
	const in  float distance_traversed )
{
	vec3 gradient = vec3(
		compute_objects_distance( position_current + vec3(Epsilon, 0.0, 0.0) ) - compute_objects_distance( position_current - vec3(Epsilon, 0.0, 0.0) ),
		compute_objects_distance( position_current + vec3(0.0, Epsilon, 0.0) ) - compute_objects_distance( position_current - vec3(0.0, Epsilon, 0.0) ),
		compute_objects_distance( position_current + vec3(0.0, 0.0, Epsilon) ) - compute_objects_distance( position_current - vec3(0.0, 0.0, Epsilon) )
	);
	return normalize( gradient );	
}

vec3 compute_background_tint(
	const in  vec3  position_current,
	const in  float distance_traversed)
{
	return background_tint;	
}

vec3 compute_objects_tint(
	const in  vec3  position_current,
	const in  float distance_traversed )
{
	return compute_objects_normal( position_current, distance_traversed );	
}

void main( void ) 
{
	vec2 uv          = gl_FragCoord.xy / resolution.xy;
	vec2 uv_centered = -1.0 + 2.0 * uv;
	
	/********************/
	/*** Camera setup ***/
	/********************/
	
	vec3 camera_initial_position     = vec3( 0.0, 0.0, -10.0 );
	vec3 camera_initial_up           = vec3( 0.0, 1.0, 0.0 );
	vec3 camera_initial_lookat       = vec3( 0.0, 0.0, 0.0 );
	
	//float mx=mouse.x*PI*2.0;
	//float my=mouse.y*PI/2.01;
	//vec3 camera_computed_position=vec3(cos(my)*cos(mx),sin(my),cos(my)*sin(mx))*6.0; 
	
	vec3 camera_computed_direction_to_target  = normalize( camera_initial_lookat - camera_initial_position );
	vec3 camera_computed_right                = normalize( cross( camera_initial_up, camera_computed_direction_to_target ) );
	vec3 camera_computed_up                   = normalize( cross( camera_computed_direction_to_target, camera_computed_right ) );
	
	vec3 camera_position_toward_focus          = camera_initial_position + camera_computed_direction_to_target;
	vec3 camera_position_toward_focus_extented = camera_position_toward_focus 
		                          + uv_centered.x * camera_computed_right * 0.8
		                          + uv_centered.y * camera_computed_up    * 0.8;
	
	vec3 coordinate_world  = vec3( 1.0, 1.0, 1.0 );
	vec3 coordinate_screen = normalize( camera_position_toward_focus_extented - camera_initial_position );
	 
	/********************/
	/*** Raymarching  ***/
	/********************/
	
	const vec3 e=vec3(0.02,0,0);
	const float maxd=100.0; //Max depth
	vec2 d=vec2(0.02,0.0);
	vec3 c,p,N;
	
	      vec3  ray_marching_position;
	      float ray_marching_distance_current = 1.0;
	      float ray_marching_distance_local   = 1.0;
	const float ray_marching_distance_max     = 100.0;
	
	      int   ray_marching_step_probe = 0;
	const int   ray_marching_step_max   = 256;
	
	for( int ray_marching_step_current = 0; ray_marching_step_current < ray_marching_step_max; ray_marching_step_current++ )
	{
		ray_marching_position = camera_initial_position + coordinate_screen * ray_marching_distance_current;
		
		ray_marching_distance_local = compute_objects_distance( ray_marching_position );
		
		ray_marching_distance_current += ray_marching_distance_local;
		
		ray_marching_step_probe = ray_marching_step_current;
		
		if( abs(ray_marching_distance_local) < Epsilon ) break;
		if( ray_marching_distance_current > ray_marching_distance_max ) break;
	}
	
	if( ray_marching_distance_current < ray_marching_distance_max ) 
	{
		gl_FragColor = vec4( 
			compute_objects_tint( 
				ray_marching_position,
				ray_marching_distance_current
			), 1.0);
	}
	else
	{
		gl_FragColor = vec4( 
			compute_background_tint( 
				ray_marching_position,
				ray_marching_distance_current
			), 1.0);
	}
}