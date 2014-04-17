#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


const float GRADIENT_DELTA = 0.0006;

const float fovy = 15.0;
const vec3 eye = vec3( 0.0, 5.0, 10.0 );
vec3 look = vec3( 0.0, -0.5, -1 ); 

float dBox( vec3 p, vec3 b )
{
	vec3 d = abs(p) - b;
	return min(max(d.x,max(d.y,d.z)),0.0) + length(max(d,0.0));
}

float dFloor( vec3 p )
{
	return dBox( p, vec3( 5.0, 0.5, 5.0 ) );
}

float dSphere( vec3 p, float r )
{
	return length( p ) - r;
}

float dTorus( vec3 p, vec2 t )
{
  vec2 q = vec2(length(p.xz)-t.x,p.y);
  return length(q)-t.y;
}

float map( vec3 p )
{
	p = vec3( mod( p.x, 10.0) - 5.0, p.y, mod( p.z, 10.0) - 5.0 );
	float theta = time;
	mat3 rot = mat3( vec3( cos( theta ), 0.0, sin( theta ) ),
			 vec3( 0.0, 1.0, 0.0 ),
			 vec3( -sin( theta ), 0.0, cos( theta ) ) );
	mat3 rotx = mat3( vec3( cos( theta ), sin( theta ), 0.0 ),
			 vec3( -sin( theta ), cos( theta ), 0.0 ),
		         vec3( 0.0, 0.0, 1.0 ) );
	vec3 off1 = rot*p - vec3( 0.0, 1.6, 0.0 );
	vec3 off2 = rotx*(p - vec3( 0.0, 3.6, 0.0 ));
	float dcross = min( dBox( off1, vec3(4.0,0.3,0.3) ), min( dBox( off1, vec3(0.3,4.0,0.3) ), dBox( off1, vec3(0.3,0.3,4.0) ) ) );
	return min( dFloor( p ), min( dTorus( off2, vec2(1.0,0.1 ) ), max( dBox( off1, vec3(4.0,1.0,0.4 ) ), max( dSphere( off1, 2.0 ), -dcross ) ) ) );
}

vec4 rayMarch( vec3 p, vec3 view )
{
	float dist;
	float totaldist = 0.0;
	
	int i = 0;
	
	for( int it = 0; it < 100; it ++ )
	{
		i++;
		dist = map( p );
		
		totaldist += dist;
		
		if( abs( dist ) < 1e-2 )
		{
			break;
		}
		p += view * dist;
	}
	if( abs( dist ) > 1e-2 ) totaldist = -1.0;
	return vec4( p, totaldist );
}

vec3 gradientNormal(vec3 p) {
    return normalize(vec3(
        map(p + vec3(GRADIENT_DELTA, 0, 0)) - map(p - vec3(GRADIENT_DELTA, 0, 0)),
        map(p + vec3(0, GRADIENT_DELTA, 0)) - map(p - vec3(0, GRADIENT_DELTA, 0)),
        map(p + vec3(0, 0, GRADIENT_DELTA)) - map(p - vec3(0, 0, GRADIENT_DELTA))));
}

float ambientOcclusion( vec3 p, vec3 dir )
{
	float sample0 = map( p + 0.1 * dir ) / 0.1;
	float sample1 = map( p + 0.2 * dir ) / 0.2;
	float sample2 = map( p + 0.3 * dir ) / 0.3;
	float sample3 = map( p + 0.4 * dir ) / 0.4;
	return ( sample0*0.05+sample1*0.1+sample2*0.25+sample3*0.6 );
}

void main( void ) {

	vec3 lpos = vec3( 4.0, 5.0, 4.0*sin( time ) );
	
	vec2 position = ( gl_FragCoord.xy - resolution / 2.0 ) / resolution.y * sin( fovy / 2.0 );
	
	position -= mouse - 0.5;
	
	look = normalize( look );

	vec3 right = cross( look, vec3( 0.0, 1.0, 0.0 ) );
	vec3 up = cross( right, look );
	vec3 view = normalize( look + position.x*right + position.y*up );
	float color = 1.0;
	
	vec3 pos = eye + view;
	
	float dist = rayMarch( pos, view ).w;
	
	if( dist < 0.0 ) color = 0.0;
	else
	{
		vec3 newpos = pos + view*dist;
		vec3 ldir = normalize( lpos - newpos );
		float ldist = length( lpos - newpos );
		vec3 norm = gradientNormal( newpos );
		float diffuse = max( 0.0, dot( norm, ldir ) );
		vec4 smarch = rayMarch( newpos + 0.1*ldir, ldir ) - vec4( newpos, 0.0 );
		float shadow = smarch.w < 0.0 ? 1.0 : length( smarch.xyz ) < ldist ?  0.0 : 1.0;
		float AO = ambientOcclusion( newpos, norm );
		color = AO*(diffuse*shadow + 0.02*diffuse)*exp( -0.05*dist );
	}

	gl_FragColor = vec4( vec3( color ), 1.0 );
}