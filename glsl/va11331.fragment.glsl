// Cube by Dima..

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

mat4 mat  = mat4 ( vec4 ( 1.0 , 0.0 , 0.0 , 0.0 ),
		   vec4 ( 0.0 , 1.0 , 0.0 , 0.0 ),
		   vec4 ( 0.0 , 0.0 , 1.0 , 0.0 ),
		   vec4 ( 0.0 , 0.0 , 0.0 , 1.0 ) );

vec2 pos;

vec4 col = vec4 ( 0.0, 0.0, 0.0, 1000.0 );
	
void RotateX ( float angle );
void RotateY ( float angle );
void RotateZ ( float angle );
void Translate ( float dx, float dy, float dz );
void Point ( vec3 p );
void Triangle ( vec3 color, vec3 a, vec3 b, vec3 c );
float d ( vec2 a, vec2 b, vec2 p );
bool oneside ( vec2 a, vec2 b, vec2 p1, vec2 p2 );
bool inside ( vec2 a, vec2 b, vec2 c );

void main( void ) {

	pos = gl_FragCoord.xy / resolution.y;
	pos.x -= resolution.y / resolution.x;
	pos -= .5;
	
	Translate(0.0,0.0,1.0);
	
	RotateX ( time );
	RotateY ( time * .5 );
	RotateZ ( time * .3 );
	
	
	Triangle( vec3 (  1.,  .0, .0), 
		  vec3 (  .2,  .2, .2),
		  vec3 (  .2, -.2, .2), 
		  vec3 ( -.2,  .2, .2) );
	Triangle( vec3 (  1.,  .0, .0), 
		  vec3 ( -.2,  .2, .2),
		  vec3 (  .2, -.2, .2), 
		  vec3 ( -.2, -.2, .2) );
	
	Triangle( vec3 (  0.,  1., .0), 
		  vec3 (  .2,  .2, -.2),
		  vec3 (  .2, -.2, -.2), 
		  vec3 ( -.2,  .2, -.2) );
	Triangle( vec3 (  0.,  1., .0), 
		  vec3 ( -.2,  .2, -.2),
		  vec3 (  .2, -.2, -.2), 
		  vec3 ( -.2, -.2, -.2) );
	
	Triangle( vec3 (  0.,  .0, 1.), 
		  vec3 (  .2,  .2, .2),
		  vec3 (  .2,  .2, -.2), 
		  vec3 ( -.2,  .2, .2) );
	Triangle( vec3 (  0.,  .0, 1.), 
		  vec3 ( -.2,  .2, .2),
		  vec3 (  .2,  .2, -.2), 
		  vec3 ( -.2,  .2, -.2) );
	
	Triangle( vec3 (  1.,  .0, 1.), 
		  vec3 (  .2,  -.2, .2),
		  vec3 (  .2,  -.2, -.2), 
		  vec3 ( -.2,  -.2, .2) );
	Triangle( vec3 (  1.,  .0, 1.), 
		  vec3 ( -.2,  -.2, .2),
		  vec3 (  .2,  -.2, -.2), 
		  vec3 ( -.2,  -.2, -.2) );
	
	Triangle( vec3 (  1.,  1., .0), 
		  vec3 (  .2,  .2, .2),
		  vec3 (  .2, -.2, .2), 
		  vec3 (  .2,  .2, -.2) );
	Triangle( vec3 (  1.,  1., .0), 
		  vec3 (  .2,  .2, -.2),
		  vec3 (  .2, -.2, .2), 
		  vec3 (  .2, -.2, -.2) );
	
	Triangle( vec3 (  1.,  1., 1.), 
		  vec3 (  -.2,  .2, .2),
		  vec3 (  -.2, -.2, .2), 
		  vec3 (  -.2,  .2, -.2) );
	Triangle( vec3 (  1.,  1., 1.), 
		  vec3 (  -.2,  .2, -.2),
		  vec3 (  -.2, -.2, .2), 
		  vec3 (  -.2, -.2, -.2) );
	
	Point ( vec3 ( 0.2 , 0.2 , 0.2 ) );
	Point ( vec3 ( 0.2 , 0.2 , -0.2 ) );
	Point ( vec3 ( 0.2 , -0.2 , 0.2 ) );
	Point ( vec3 ( 0.2 , -0.2 , -0.2 ) );
	Point ( vec3 ( -0.2 , 0.2 , 0.2 ) );
	Point ( vec3 ( -0.2 , 0.2 , -0.2 ) );
	Point ( vec3 ( -0.2 , -0.2 , 0.2 ) );
	Point ( vec3 ( -0.2 , -0.2 , -0.2 ) );
	
	
	gl_FragColor = vec4( col.xyz, 1.0 );

}

void Point ( vec3 p )
{
	p = ( mat * vec4 ( p , 1.0 ) ).xyz;
	
	float d = distance ( pos , p.xy );
	
	if ( d < .3 )
	if ( p.z < col.a ) {
		col.b += max ( 1.0 - pow ( d * 5.0 , .1 ) , 0.0 );
	}
}

void RotateZ ( float angle )
{
	float c = cos ( angle );
	float s = sin ( angle );
	mat = mat * mat4 ( vec4 ( c   , s   , 0.0 , 0.0 ),
			   vec4 ( -s  , c   , 0.0 , 0.0 ),
			   vec4 ( 0.0 , 0.0 , 1.0 , 0.0 ),
			   vec4 ( 0.0 , 0.0 , 0.0 , 1.0 ) );	
}

void RotateY ( float angle )
{
	float c = cos ( angle );
	float s = sin ( angle );
	mat = mat * mat4 ( vec4 ( c   , 0.0 , -s  , 0.0 ),
			   vec4 ( 0.0 , 1.0 , 0.0 , 0.0 ),
			   vec4 ( s   , 0.0 , c   , 0.0 ),
			   vec4 ( 0.0 , 0.0 , 0.0 , 1.0 ) );	
}

void RotateX ( float angle )
{
	float c = cos ( angle );
	float s = sin ( angle );
	mat = mat * mat4 ( vec4 ( 1.0 , 0.0 , 0.0 , 0.0 ),
			   vec4 ( 0.0 , c   , s   , 0.0 ),
			   vec4 ( 0.0 , -s  , c   , 0.0 ),
			   vec4 ( 0.0 , 0.0 , 0.0 , 1.0 ) );	
}

void Translate ( float dx, float dy, float dz )
{
	mat = mat * mat4 ( vec4 ( 1.0 , 0.0 , 0.0 , 0.0 ),
			   vec4 ( 0.0 , 1.0 , 0.0 , 0.0 ),
			   vec4 ( 0.0 , 0.0 , 1.0 , 0.0 ),
			   vec4 ( dx  , dy  , dz  , 1.0 ) );
}

float d ( vec2 a, vec2 b, vec2 p )
{
	return ( a.x - p.x ) * ( b.y - p.y ) - ( b.x - p.x ) * ( a.y - p.y ); 
}

bool oneside ( vec2 a, vec2 b, vec2 p1, vec2 p2 )
{
	return d ( a , b , p1 ) * d ( a , b , p2 ) > 0.0;
}

bool inside ( vec2 a, vec2 b, vec2 c )
{	
	return oneside ( a , b , c , pos ) && oneside ( a , c , b , pos ) && oneside ( c , b , a , pos );
}

void Triangle ( vec3 color, vec3 a, vec3 b, vec3 c )
{
	a = ( mat * vec4 ( a , 1.0 ) ).xyz;
	b = ( mat * vec4 ( b , 1.0 ) ).xyz;
	c = ( mat * vec4 ( c , 1.0 ) ).xyz;
	
	if ( inside ( a.xy, b.xy, c.xy ) ) {	
		float A = ( b.y - a.y ) * ( c.z - a.z ) - ( b.z - a.z ) * ( c.y - a.y );
		float B = ( b.z - a.z ) * ( c.x - a.x ) - ( b.x - a.x ) * ( c.z - a.z );
		float C = ( b.x - a.x ) * ( c.y - a.y ) - ( b.y - a.y ) * ( c.x - a.x );
		float D = - ( A * a.x + B * a.y + C * a.z );
		
		if ( abs ( C ) < 0.0001 ) C = 0.0001;
		float z = - ( A * pos.x + B * pos.y + D ) / C;
		
		if ( z < col.a ) {
			col.r = max ( color.r - z * .7 , 0.0 );
			col.g = max ( color.g - z * .7 , 0.0 );
			col.b = max ( color.b - z * .7 , 0.0 );
			col.a = z;
		}
	}
	
}