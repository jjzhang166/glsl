#ifdef GL_ES
precision mediump float;
#endif

// By Liam Boone. The base code for the ray marching comes from an earlier attempt by me (http://glsl.heroku.com/e#5059.2) 
// and heavily relies on the math exposed here: http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
// If you're feeling brave, try to chance the #ifdef on line 178 to #ifndef
// Static view

uniform float u_time;
float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define EPS       0.001
#define EPS1      0.01
#define PI        3.1415926535897932
#define HALFPI    1.5707963267948966
#define QUARTPI   0.7853981633974483
#define ROOTTHREE 0.57735027
#define HUGEVAL   1e20
#define MAX_ITER  128


//
// Description : Array and textureless GLSL 2D/3D/4D sim
//               noise functions.
//      Author : Ian McEwan, Ashima Arts.
//  Maintainer : ijm
//     Lastmod : 20110822 (ijm)
//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
//               Distributed under the MIT License. See LICENSE file.
//               https://github.com/ashima/webgl-noise
// 

vec3 mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 mod289(vec4 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 permute(vec4 x) {
     return mod289(((x*34.0)+1.0)*x);
}

vec4 taylorInvSqrt(vec4 r)
{
  return 1.79284291400159 - 0.85373472095314 * r;
}

float snoise(vec3 v)
{ 
  const vec2  C = vec2(1.0/6.0, 1.0/3.0) ;
  const vec4  D = vec4(0.0, 0.5, 1.0, 2.0);

// First corner
  vec3 i  = floor(v + dot(v, C.yyy) );
  vec3 x0 =   v - i + dot(i, C.xxx) ;

// Other corners
  vec3 g = step(x0.yzx, x0.xyz);
  vec3 l = 1.0 - g;
  vec3 i1 = min( g.xyz, l.zxy );
  vec3 i2 = max( g.xyz, l.zxy );

  //   x0 = x0 - 0.0 + 0.0 * C.xxx;
  //   x1 = x0 - i1  + 1.0 * C.xxx;
  //   x2 = x0 - i2  + 2.0 * C.xxx;
  //   x3 = x0 - 1.0 + 3.0 * C.xxx;
  vec3 x1 = x0 - i1 + C.xxx;
  vec3 x2 = x0 - i2 + C.yyy; // 2.0*C.x = 1/3 = C.y
  vec3 x3 = x0 - D.yyy;      // -1.0+3.0*C.x = -0.5 = -D.y

// Permutations
  i = mod289(i); 
  vec4 p = permute( permute( permute( 
             i.z + vec4(0.0, i1.z, i2.z, 1.0 ))
           + i.y + vec4(0.0, i1.y, i2.y, 1.0 )) 
           + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));

// Gradients: 7x7 points over a square, mapped onto an octahedron.
// The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)
  float n_ = 0.142857142857; // 1.0/7.0
  vec3  ns = n_ * D.wyz - D.xzx;

  vec4 j = p - 49.0 * floor(p * ns.z * ns.z);  //  mod(p,7*7)

  vec4 x_ = floor(j * ns.z);
  vec4 y_ = floor(j - 7.0 * x_ );    // mod(j,N)

  vec4 x = x_ *ns.x + ns.yyyy;
  vec4 y = y_ *ns.x + ns.yyyy;
  vec4 h = 1.0 - abs(x) - abs(y);

  vec4 b0 = vec4( x.xy, y.xy );
  vec4 b1 = vec4( x.zw, y.zw );

  //vec4 s0 = vec4(lessThan(b0,0.0))*2.0 - 1.0;
  //vec4 s1 = vec4(lessThan(b1,0.0))*2.0 - 1.0;
  vec4 s0 = floor(b0)*2.0 + 1.0;
  vec4 s1 = floor(b1)*2.0 + 1.0;
  vec4 sh = -step(h, vec4(0.0));

  vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;
  vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;

  vec3 p0 = vec3(a0.xy,h.x);
  vec3 p1 = vec3(a0.zw,h.y);
  vec3 p2 = vec3(a1.xy,h.z);
  vec3 p3 = vec3(a1.zw,h.w);

//Normalise gradients
  vec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
  p0 *= norm.x;
  p1 *= norm.y;
  p2 *= norm.z;
  p3 *= norm.w;

// Mix final noise value
  vec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);
  m = m * m;
  return 42.0 * dot( m*m, vec4( dot(p0,x0), dot(p1,x1), 
                                dot(p2,x2), dot(p3,x3) ) );
}

const float fovy = 0.785398163;
vec3 eye = vec3( 0.0, 5.0, 10.0 );
vec3 look = vec3( 0.0, -0.25, -1.0 ); 

float dBox( vec3 p, vec3 b )
{
	vec3 d = abs(p) - b;
	return min(max(d.x,max(d.y,d.z)),0.0) + length(max(d,0.0));
}

float d2Box( vec3 p, vec3 b )
{
	float box1 = dBox( p + vec3( 0.5, 0.0, 0.0 ), b );
	float box2 = dBox( p - vec3( 0.5, 0.0, 0.0 ) , b );
	return min(box1, box2);
}

float dFloor( vec3 p )
{
	return dBox( p, vec3( HUGEVAL, 0.2, HUGEVAL ) );
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

float dCone( vec3 p, vec2 c )
{
    // c must be normalized
    float q = length(p.xy);
    return dot(c,vec2(q,p.z));
}
vec3 opTwist( vec3 p, float t )
{
    float c = cos(t*p.y);
    float s = sin(t*p.y);
    mat2  m = mat2(c,-s,s,c);
    vec3  q = vec3(m*p.xz,p.y);
    return q.xzy;
}

float map( vec3 p, out int mat )
{
	#ifdef NOISE
	float noise = 0.01*snoise( p*3.0 + time );
	#else
	float noise = 0.0;
	#endif
	vec3 q = vec3( mod( p.x, 5.0) - 2.5, p.y - 2.0, mod( p.z, 5.0) - 2.5 );
	
	float ring = dTorus( p - vec3( 0.0, 1.0, 0.0 ), vec2( 15.0, 1.0 ) ) + noise;
	float column = d2Box( opTwist(q, 5.0 + sin( time ) ), vec3( 0.05, HUGEVAL, 0.1 ) );
	
	float ball = dSphere( q - vec3( 0.0, 1.0, 0.0 ), 0.5 ) + noise;
	float bounds = dFloor( p ) + noise;	
	
	float dist = min( ring, min( bounds, min( ball, column ) ) );
	if( dist == ball )
	{
		mat = 1;
	}
	else if( dist == ring )
	{
		mat = 2;
	}
	else if( dist == column )
	{
		mat = 3;
	}
	else
	{
		mat = 0;
	}
	return dist;
}

vec4 rayMarch( vec3 p, vec3 view, out int mat )
{
	float dist;
	float totaldist = 0.0;
	
	int i = 0;
	
	for( int it = 0; it < MAX_ITER; it ++ )
	{
		i++;
		dist = map( p, mat ) * 0.8;
		
		totaldist += dist;
		
		if( abs( dist ) < EPS )
		{
			break;
		}
		p += view * dist;
	}
	if( abs( dist ) > 1e-2 ) totaldist = -1.0;
	return vec4( p, totaldist );
}

vec3 gradientNormal(vec3 p) {
	int m;
	return normalize(vec3(
		map(p + vec3(EPS, 0, 0), m) - map(p - vec3(EPS, 0, 0), m),
		map(p + vec3(0, EPS, 0), m) - map(p - vec3(0, EPS, 0), m),
		map(p + vec3(0, 0, EPS), m) - map(p - vec3(0, 0, EPS), m)));
}

float getAmbientOcclusion( vec3 p, vec3 dir )
{
	int m;
	float sample0 = map( p + 0.1 * dir, m ) / 0.1;
	float sample1 = map( p + 0.2 * dir, m ) / 0.2;
	float sample2 = map( p + 0.3 * dir, m ) / 0.3;
	float sample3 = map( p + 0.4 * dir, m ) / 0.4;
	return ( sample0*0.05+sample1*0.1+sample2*0.25+sample3*0.6 );
}

//Yanked from nop's code
// source: the.savage@hotmail.co.uk
#define SS_K  15.0
float getShadow (vec3 pos, vec3 toLight, float lightDist) {
  float shadow = 1.0;

  float t = EPS1;
  float dt;

  for(int i=0; i<MAX_ITER; ++i)
  {
    int m;
    dt = map(pos+(toLight*t), m) * 0.8;
    
    if(dt < EPS)    // stop if intersect object
      return 0.0;

    shadow = min(shadow, SS_K*(dt/t));
    
    t += dt;
    
    if(t > lightDist)   // stop if reach light
      break;
  }
  
  return clamp(shadow, 0.0, 1.0);
}
#undef SS_K

vec3 rayCast( vec3 pos, vec3 lpos, vec3 view, out int mat, out vec3 newpos )
{
	float dist = rayMarch( pos, view, mat ).w;
	vec3 color = vec3( 1.0 );
	
	if( mat == 1 )
	{
		color = vec3( 1.0, 0.5, 0.5 );	
	}
	else if( mat == 2 )
	{
		color = vec3( 0.5, 1.0, 0.5 );	
	}
	else if( mat == 3 )
	{
		color = vec3( 0.5, 0.5, 1.0 );	
	}
	
	if( dist < 0.0 ) color = vec3( 0.0 );
	else
	{ 
		newpos = pos + view*dist;
		vec3 ldir = normalize( lpos - newpos );
		float ldist = length( lpos - newpos );
		vec3 norm = gradientNormal( newpos );
		float diffuse = max( 0.0, dot( norm, ldir ) );
		float specular = pow( max( 0.0, dot( reflect( view, norm ), ldir ) ), 150.0 );
		float shadow = getShadow( newpos + 0.01*ldir, ldir, distance( lpos, newpos ) );
		float AO = getAmbientOcclusion( newpos, norm );
		float fog = exp( -0.05*dist );
		color = color*(AO*(diffuse*shadow + 0.1)*fog);
		color += vec3(5.0*specular*fog);
	}
	return color;
}
void main( void ) {

	time = u_time;
	vec3 lpos = vec3( 0.0, 4.0, 0.0 );
	vec2 offset = mouse;
	
	eye = vec3( 15.0*sin( time / 20.0 ), 3.0, 15.0*cos( time / 20.0 ) );
	look = -eye;
	
	vec2 position = ( gl_FragCoord.xy - resolution / 2.0 ) / resolution.y * sin( fovy / 2.0 );
	
	position -= mouse - 0.5;

	look = normalize( look );

	vec3 right = cross( look, vec3( 0.0, 1.0, 0.0 ) );
	vec3 up = cross( right, look );
	vec3 view = normalize( look + position.x*right + position.y*up );
	vec3 color = vec3( 1.0 );
	
	vec3 pos = eye + view;
	vec3 newpos;
	int mat;
	
	color = rayCast( pos, lpos, view, mat, newpos );
	for( int i = 0; i < 2; i ++ )
	{	
		if( mat == 0 || mat == 1 )
		{
			vec3 newview = reflect( view, gradientNormal( newpos ) );
			color = color * 0.3 + 0.7 * rayCast( newpos + 0.01*newview, lpos, newview, mat, newpos );
		}
	}
	gl_FragColor = vec4( color, 1.0 );
}