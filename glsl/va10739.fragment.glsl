#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.141592653589;

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

float remap(float num, float in_min, float in_max, float out_min, float out_max)
{
  float zeroToOne = (num - in_min) / (in_max - in_min);
  return zeroToOne * (out_max - out_min) + out_min;
}

bool traceToSphere(vec3 o, vec3 dir, vec3 center, float radius, out vec3 P)
{
    // direction squared
    float A = dot( dir, dir );
    float B = dot(2.0*(o-center), dir);
    float C = dot( o-center, o-center ) - (radius*radius);
    float disc = B*B - 4.0*A*C;

    P = vec3(0);
	// hit = false;
   
    if( disc < 0.0 )
    {
        return false;
    }
    else
    {
        // hit = true;
   
        float q = (-B - disc) / 2.0;
        if( B < 0.0 ) q = (-B + disc) / 2.0;
       
        float t0 = q / A;
        float t1 = C / q;
	float t = 0.0;
        // float t = min( abs(t0), abs(t1));
        
		// make sure t0 is smaller than t1
		if (t0 > t1)
		{
			// if t0 is bigger than t1 swap them around
			float temp = t0;
			t0 = t1;
			t1 = temp;
		}
	
		// if t1 is less than zero, the object is in the ray's negative direction
		// and consequently the ray misses the sphere
		if (t1 < 0.0)
			return false;
	
		// if t0 is less than zero, the intersection point is at t1
		if (t0 < 0.0)
			t = t1;
		// else the intersection point is at t0
		else
			t = t0;
		
        P = o + (dir*t);
		return true;
    }
}

vec3 getCamRay(float fov, vec2 position)
{
  float invTanAng = tan(radians(fov) / 2.0);
  return normalize( vec3( position.x * invTanAng, position.y * invTanAng, 1.0 ) );
}

/*
vec3 getDirFromCamera(vec3 origin, float fov, vec2 pixel)
{
	float clipSide = tan( radians(fov) );
	vec3 clipCorner = vec3(clipSide, clipSide, 0.0);
	vec3 clipPlaneCorner = clipCorner + origin;
	
	vec3 pixel3D = vec3( pixel, 1.0 );
	return normalize( (pixel3D*clipCorner) - (clipCorner/2.0) );
}
*/

float checker2D(vec2 coord, float frequency)
{
	//float checkerX = floor(mod(coord.x*4.0, 1.0) + 0.5) ;
	//float checkerY = floor(mod(coord.y*4.0, 1.0) + 0.5) ;
	float patternX = 1.0 - floor( mod(coord.x*frequency, 1.0) * 2.0);
	float patternY = 	   floor( mod(coord.y*frequency, 1.0) * 2.0);
	//float pattern = 
	//float tex = checkerX - checkerY;
	//if( checkerX == checkerY )
		//tex = 1.0;
	return abs(patternX - patternY);
}

float checker3D(vec3 coord, float frequency)
{
	float c2d = checker2D( coord.xy, frequency );
	float patternZ = floor( mod(coord.z*frequency, 1.0) * 2.0 );
	return abs( c2d - patternZ );
}

bool traceToGround(vec3 o, vec3 dir, out vec3 P)
{
	bool below = (o.y < 0.0) && (dir.y < 0.0);
	bool above = (o.y > 0.0) && (dir.y > 0.0);
	if( !below && !above )
	{
		/// float t = length( (dir/dir.y) * o.y) ;
		// P  = o * (t*dir);
		P = o + (dir/dir.y)*o.y;
		return true;
	}
	return false;
}

struct VERTEX
{
  vec3 P;
  vec3 C;
  vec2 uv;
};
	
struct TRIANGLE
{
  VERTEX A;
  VERTEX B;
  VERTEX C;
	
  vec3 N;
  float area;
};

/*	
bool insideTriangle(TRIANGLE t, inout VERTEX v)
{
  float fudge = 1.0;
	
	TRIANGLE invT;
	vec3 pToA = v.P - t.A.P;
	vec3 pToB = v.P - t.B.P;
	vec3 pToC = v.P - t.C.P;
	float pToALen = length(pToA);
	float pToBLen = length(pToB);
	float pToCLen = length(pToC);
	float i_pToALen = 1.0 / pToALen;
	float i_pToBLen = 1.0 / pToBLen;
	float i_pToCLen = 1.0 / pToCLen;
	float totalLen = i_pToALen + i_pToBLen + i_pToCLen;
	float weightA = pToALen / length( t.A.P - ((t.B.P+t.C.P)/2.0) );
	float weightB = pToBLen / length( t.B.P - ((t.A.P+t.C.P)/2.0) );
	float weightC = pToCLen / length( t.C.P - ((t.A.P+t.B.P)/2.0) );
	//float weightB = i_pToBLen / totalLen;
	//float weightC = i_pToCLen / totalLen;
	
	v.C = weightA*t.A.C + weightB*t.B.C + weightC*t.C.C;
	v.uv = weightA*t.A.uv + weightB*t.B.uv + weightC*t.C.uv;
	
	
	invT.A.P = (v.P - t.A.P)/pToALen * fudge;
	invT.B.P = (v.P - t.B.P)/pToBLen * fudge;
  	invT.C.P = (v.P - t.C.P)/pToCLen * fudge;
	
	float dotAccum = 0.0;
	dotAccum += dot(invT.A.P, invT.B.P);
	dotAccum += dot(invT.B.P, invT.C.P);
	dotAccum += dot(invT.C.P, invT.A.P);
	
	if( dotAccum < -1.0 )
	  return true;
	
	return false;
}*/

bool insideTriangle(TRIANGLE t, inout VERTEX v)
{	
	
  vec3 crossAB = cross( t.B.P - t.A.P,  v.P - t.A.P);
  if( dot(crossAB, t.N) < 0.0 ) return false;
  vec3 crossBC = cross( t.C.P - t.B.P,  v.P - t.B.P);
  if( dot(crossBC, t.N) < 0.0 ) return false;	
  vec3 crossCA = cross( t.A.P - t.C.P,  v.P - t.C.P);
  if( dot(crossCA, t.N) < 0.0 ) return false;	
	
  float weightA = length( crossBC ) / 2.0;
  float weightB = length( crossCA ) / 2.0;
  float weightC = length( crossAB ) / 2.0;
	
  v.uv = vec2(0.0);
  v.uv += t.A.uv * weightA;
  v.uv += t.B.uv * weightB;
  v.uv += t.C.uv * weightC;
  v.uv /= t.area;
	 
  return true;
}	    
	
void calculateNormal(inout TRIANGLE t)
{
  vec3 normal = cross( t.B.P - t.A.P, t.C.P - t.A.P );
  t.N =  normalize( normal );
  t.area = length( normal ) / 2.0;
}
	
bool traceToTriangle(TRIANGLE t, vec3 origin, vec3 rayDir, out VERTEX v)
{
  float normalDotRayDir = dot( t.N, rayDir );
  if( normalDotRayDir == 0.0 )
    return false;
  
  float d = dot( t.N, t.A.P );
  float rayLength = (d - dot(t.N, origin) ) / normalDotRayDir;
	
  v.P = origin + rayLength*rayDir;

  if( rayLength < 0.0 )
    return false;
  bool hit = insideTriangle(t, v);
		
  return hit;
}

struct SAMPLER
{
  vec3[16] sBuf1;
  vec3[16] sBuf2;
};

// vec3[8] samples;	

// A single iteration of Bob Jenkins' One-At-A-Time hashing algorithm.
/*int hash( int x )
{
    x += ( x << 10 );
    x ^= ( x >>  6u );
    x += ( x <<  3u );
    x ^= ( x >> 11u );
    x += ( x << 15u );
    return x;
}

// Compound versions of the hashing algorithm I whipped together.
uint hash( uvec2 v ) { return hash( v.x ^ hash(v.y)                         ); }
uint hash( uvec3 v ) { return hash( v.x ^ hash(v.y) ^ hash(v.z)             ); }
uint hash( uvec4 v ) { return hash( v.x ^ hash(v.y) ^ hash(v.z) ^ hash(v.w) ); }
*/
	
float modulo(float x, float y)
{
	return x - y * floor(x/y);
}
	
void main( void )
{
	vec2 ratio = vec2(resolution.x / resolution.y, 1.0);
	vec2 pixelSize = (1.0 / resolution) * ratio;
	vec2 uv = ( gl_FragCoord.xy / resolution.xy );
	vec2 position = uv * ratio; // + pixelSize/2.0;
	vec2 shiftNDC = position - (ratio/2.0);
	
	float sinTime = remap( sin(time), -1.0, 1.0, -2.0, 2.0);
	
	
	TRIANGLE t1;
	t1.A.P = vec3( 0.0, -0.05, -1.0 );
	t1.B.P = vec3( 20.0, -0.1, 64.0 );
	t1.C.P = vec3( -20.0, -0.1, 64.0 );
	t1.A.C = vec3(1.0, 0.0, 0.0);
	t1.B.C = vec3(0.0, 1.0, 0.0);
	t1.C.C = vec3(0.0, 0.0, 1.0);
	t1.A.uv = vec2(0.0, 0.0);
	t1.B.uv = vec2(0.0, 1.0);
	t1.C.uv = vec2(1.0, 1.0);
	calculateNormal(t1);
   
	vec3 finalColor = vec3(0.0);
	vec3 bufferA = vec3(0.0);
	vec3 bufferB = vec3(0.0);
	float countA = 0.0;
	float countB = 0.0;
	const int buffers = 2;
	const int samples = 8;
	for(int i = 0; i < samples*buffers; i++)
	{
            VERTEX hitV;
	    float randX = snoise( vec3(shiftNDC.x*10000.0*float(i), 0.0, 0.0) );
	    float randY = snoise( vec3(shiftNDC.y*10000.0*float(i), 0.0, 0.0) );
	    vec2 rand = vec2( randX, randY );
	    vec3 rayDir = getCamRay( 45.0, shiftNDC + pixelSize*rand );
	    bool hit = traceToTriangle( t1, vec3(0.0), rayDir, hitV); 
	    float tex = checker2D( hitV.uv, 128.0); 
	    //float tex = snoise( vec3(hitV.uv, 0.0) * 1000.0 );
	    //tex = remap(tex, -1.0, 1.0, 0.0, 1.0);
		
	    int nc_buffers = buffers;
	    float i_mod_buffers = modulo( float(i), float(buffers) );
	    if(hit)
	      if( i_mod_buffers == 0.0 ) {
	        bufferA += tex;
		countA++;
	      }
	      else {
	        bufferB += tex;
		countB++;
	      }
	    if( length(bufferA - bufferB) < 0.0 )
	      break;
	}
	bufferA /= countA;
	bufferB /= countB;
	finalColor = (bufferA+bufferB) / 2.0;
	//finalColor = bufferA - bufferB;
	//float tex = checker3D( hitV.P, 4.0);
	
	// float tex = snoise( hitV.P * 5.0 );
	
	gl_FragColor = vec4( finalColor, 1.0 );
	gl_FragColor = vec4( countA / float(samples) );
	gl_FragColor = vec4( length(bufferA - bufferB) );
}






