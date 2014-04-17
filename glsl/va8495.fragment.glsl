#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 position;

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

mat3 rotationMatrix(vec3 axis, float angle)
{
    axis = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;
    
    return mat3(oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
                oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
                oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c);
}

float sdTorus( vec3 p, vec2 t )
{
  vec2 q = vec2(length(p.xz)-t.x,p.y);
  return length(q)-t.y;
}
float sdSphere( vec3 p, float s )
{
  return length(p)-s;
}
float sdBox( vec3 p, vec3 b )
{
  vec3 d = abs(p) - b;
  return min(max(d.x,max(d.y,d.z)),0.0) +
         length(max(d,0.0));
}

float sdPlane( vec3 p, vec4 n )
{
  // n must be normalized
  return dot(p,n.xyz) + n.w;
}

float aspect_ratio = resolution.y / resolution.x;

float primdist( vec3 p)
{
	float timechange = 5.;
	float delta = mod(time,timechange)/timechange;
	if (mod(time/timechange,2.)>=1.)
		delta = 1.-delta;
	float sphere = sdSphere(p,0.2*3.14/2.); //+ (snoise(vec3(position+mouse,0))*2.-1.)/30.;
	float box = sdBox(p,vec3(0.2,0.2,0.2));//+ abs((snoise(vec3(position+mouse,time))*2.-1.)/30.);
	float torus = sdTorus(p,vec2(0.3,0.2)); //+ (snoise(vec3(position,time))*2.-1.)/100.;
	float plane = sdPlane(p+vec3(0,0.3,0),vec4(0,1,0,0));//+ (snoise(vec3(position,time))*2.-1.)/100.;
	return mix(sphere,box,delta);
	//return min(sphere,box);
	return sphere;
	//return box;
	//return min(plane,box);
}

vec3 primnormal(vec3 p) 
{
	float eps = 0.001;
	return normalize( vec3(
		primdist(p+vec3(eps,0,0)) - primdist(p-vec3(eps,0,0)),
		primdist(p+vec3(0,eps,0)) - primdist(p-vec3(0,eps,0)),
		primdist(p+vec3(0,0,eps)) - primdist(p-vec3(0,0,eps))) );
}

#define MAX_RAY_STEPS 64
float ray_scale    = (1.0 / max(resolution.x, resolution.y)) * 0.5;
void main( void ) {

	position = gl_FragCoord.xy / resolution.y;
	position.x = position.x - 1.;
	position.y = position.y - resolution.y / resolution.x;

	//mat3 mat = mat3(1);
	mat3 mat = rotationMatrix(vec3(1,0,0),(mouse.y-.5)*3.14) * rotationMatrix(vec3(0,1,0),-(mouse.x-.5)*3.14);
	vec3 raypos = mat * vec3 (position.x, position.y, -1);
	//vec3 raydir = normalize(vec3 (mouse.x,mouse.y,1.-(mouse.x+mouse.y)));
	vec3 raydir = mat * vec3(0,0,1);
	
	vec4 color = vec4(0.,0.,0.,0.);
	float dist;
	float len = 0.;
	float epsilon = 0.;
	int iter = 0;
	bool done = false;
	float stepsize = 1.;
	bool sky = false;
	for(int i=0;i<MAX_RAY_STEPS;i++) {
        	if (!done)
		{
			iter++;
			dist = primdist(raypos);
			raypos += dist * raydir * stepsize;
        		len += dist * stepsize;
			if(dist<epsilon)
			{
				done = true;
				break;
			}
			//if (dist>lastDist)
			if ((len > 100.))
			{
				sky = true;
			}
	        	epsilon  = ray_scale * len;
		    }
	    }
	gl_FragColor = vec4(float(iter)/float(MAX_RAY_STEPS));
	//gl_FragColor = vec4((1.-len)*100.);
	//gl_FragColor = color;
	vec3 normal = primnormal(raypos);
	gl_FragColor = vec4(vec3(dot(normal,-raydir)),1);
	//gl_FragColor.x = dot(normal,-raydir);
	//gl_FragColor.x = done ? 0. : 1.;
	//gl_FragColor.xyz = (normal+1.)/2.;
	//gl_FragColor.xyz = vec3(length(normal));
	//if ((dot(normal,-raydir)<0.) || (length(normal)<=0.01))
	if (sky)
		gl_FragColor = vec4(0.,.5,.5,0.);
	//gl_FragColor = vec4( position,0., 1.0 );
	//if ((position.x > 1.) || (position.x < 0.)
	//   || (position.y < 0.) || (position.y > 1.))
	//	gl_FragColor = vec4(1.);

}