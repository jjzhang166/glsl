// Based on the spinning cube code by Dima, pimped up by Vlad

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
	pos -= mouse;
	
	
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

vec3 CalculateSrfNormals(vec3 a, vec3 b, vec3 c)
{
	vec3 u = a - b;
	vec3 v = b - c;
	
	float Nx = ( b.y - a.y ) * ( c.z - a.z ) - ( b.z - a.z ) * ( c.y - a.y );
	float Ny = ( b.z - a.z ) * ( c.x - a.x ) - ( b.x - a.x ) * ( c.z - a.z );
	float Nz = ( b.x - a.x ) * ( c.y - a.y ) - ( b.y - a.y ) * ( c.x - a.x );
	
	float D = (  Nx * a.x + Ny * a.y + Nz * a.z );
	
	vec3 outNormal = vec3(Nx, Ny, Nz) / D;
	
	return normalize(outNormal);
}

void Triangle ( vec3 color, vec3 a, vec3 b, vec3 c )
{	
	//light positions
	vec3 light0 = vec3(0.5,0.9,0.4);
	vec3 light1 = vec3(0.9,0.9,0.4);
	vec3 light2 = vec3(0.5,0.9,0.4);
	vec3 light3 = vec3(0.5,0.9,0.9);
	

	//vector normal
	//vec3 triNormal = CalculateSrfNormals(a, b, c);
	
	//Light colours
	
	
	a = ( mat * vec4 ( a , 1.0 ) ).xyz;
	b = ( mat * vec4 ( b , 1.0 ) ).xyz;
	c = ( mat * vec4 ( c , 1.0 ) ).xyz;
	
	
	if ( inside ( a.xy, b.xy, c.xy ) ) 
	{	
		
		vec3 triAngle = CalculateSrfNormals(a, b, c);
		
		//light0
		/*float dist0 = distance(triAngle, light0);
		vec3 light0_color = vec3(0.6, 0.1, 0.8);
		float alpha0 = 1.0 / (dist0*0.75);
		vec4 light0_fColor = vec4(light0_color, 1.0)*vec4(alpha0, alpha0, alpha0, 1.0);
		
		//light1
		float dist1 = distance(triAngle, light1);
		vec3 light1_color = vec3(0.2, 0.76, 0.3);
		float alpha1 = 1.0 / (dist1*0.75);
		vec4 light1_fColor = vec4(light1_color, 1.0)*vec4(alpha1, alpha1, alpha1, 1.0);
		
		//light2
		float dist2 = distance(triAngle, light2);
		vec3 light2_color = vec3(0.1, 0.4, 0.3);
		float alpha2 = 1.0 / (dist2*0.75);
		vec4 light2_fColor = vec4(light2_color, 1.0)*vec4(alpha2, alpha2, alpha2, 1.0);
		
		//light3
		float dist3 = distance(triAngle, light3);
		vec3 light3_color = vec3(0.3, 0.6, 0.1);
		float alpha3 = 1.0 / (dist3*0.75);
		vec4 light3_fColor = vec4(light3_color, 1.0)*vec4(alpha3, alpha3, alpha3, 1.0);*/
		
		if ( abs ( triAngle.z ) < 0.0001 ) triAngle.z = 0.0001;
		
		float z = - ( triAngle.x * pos.x + triAngle.y * pos.y + triAngle.z ) / 1.0;
		
		vec3 surfaceToLight = normalize((light0 ) - triAngle);
		
		float dif = dot(triAngle, surfaceToLight) ;
		
		if ( z < col.a ) 
		{
			//col.r = max ( color.r - z * .7 , 0.0 );
			//col.g = max ( color.g - z * .7 , 0.0 );
			//col.b = max ( color.b - z * .7 , 0.0 );
			
			col.xyz += surfaceToLight;
			
			col.a = z;
		}

		//col.xyz += surfaceToLight;	
	}
	
	
}