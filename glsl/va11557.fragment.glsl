// Created by inigo quilez - iq/2013
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

// A list of usefull distance function to simple primitives, and an example on how to 
// do some interesting boolean operations, repetition and displacement.
//
// More info here: http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm

precision mediump float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float sdPlane( vec3 p )
{
    return p.y;
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

float udRoundBox( vec3 p, vec3 b, float r )
{
  return length(max(abs(p)-b,0.0))-r;
}

float sdTorus( vec3 p, vec2 t )
{
  vec2 q = vec2(length(p.xz)-t.x,p.y);
  return length(q)-t.y;
}

float sdHexPrism( vec3 p, vec2 h )
{
    vec3 q = abs(p);
    return max(q.z-h.y,max(q.x+q.y*0.57735,q.y*1.1547)-h.x);
}

float sdCapsule( vec3 p, vec3 a, vec3 b, float r )
{
    vec3 pa = p - a;
    vec3 ba = b - a;
    float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
    
    return length( pa - ba*h ) - r;
}

float sdTriPrism( vec3 p, vec2 h )
{
    vec3 q = abs(p);
    return max(q.z-h.y,max(q.x*0.866025+p.y*0.5,-p.y)-h.x*0.5);
}

float sdCylinder( vec3 p, vec2 h )
{
  return max( length(p.xz)-h.x, abs(p.y)-h.y );
}

float sdCone( in vec3 p, in vec3 c )
{
    vec2 q = vec2( length(p.xz), p.y );
    return max( max( dot(q,c.xy), p.y), -p.y-c.z );
}

float length2( vec2 p )
{
    return sqrt( p.x*p.x + p.y*p.y );
}

float length6( vec2 p )
{
    p = p*p*p; p = p*p;
    return pow( p.x + p.y, 1.0/6.0 );
}

float length8( vec2 p )
{
    p = p*p; p = p*p; p = p*p;
    return pow( p.x + p.y, 1.0/8.0 );
}

float sdTorus82( vec3 p, vec2 t )
{
  vec2 q = vec2(length2(p.xz)-t.x,p.y);
  return length8(q)-t.y;
}

float sdTorus88( vec3 p, vec2 t )
{
  vec2 q = vec2(length8(p.xz)-t.x,p.y);
  return length8(q)-t.y;
}

float sdCylinder6( vec3 p, vec2 h )
{
  return max( length6(p.xz)-h.x, abs(p.y)-h.y );
}

//----------------------------------------------------------------------

float opS( float d1, float d2 )
{
    return max(-d2,d1);
}

vec2 opU( vec2 d1, vec2 d2 )
{
    return (d1.x<d2.x) ? d1 : d2;
}

vec3 opRep( vec3 p, vec3 c )
{
    return mod(p,c)-0.5*c;
}

vec3 opTwist( vec3 p )
{
    float  c = cos(10.0*p.y+10.0);
    float  s = sin(10.0*p.y+10.0);
    mat2   m = mat2(c,-s,s,c);
    return vec3(m*p.xz,p.y);
}


//----------------------------------------------------------------------

mat3 rotation_matrix(vec3 d,vec3 z )
{
    vec3  v = cross( z, d );
    float c = dot( z, d );
    float k = (1. - c)/(1.-c*c);

    return mat3( v.x*v.x*k + c,   v.y*v.x*k - v.z, v.z*v.x*k + v.y,
                 v.x*v.y*k + v.z, v.y*v.y*k + c,   v.z*v.y*k - v.x,
                 v.x*v.z*k - v.y, v.y*v.z*k + v.x, v.z*v.z*k + c);
}

//----------------------------------------------------------------------

vec2 map( in vec3 pos )
{
    float vel[7];
    vel[0] = time * 1.5;
    vel[1] = time * .95;
    vel[2] = time * .5;
    vel[3] = time * .45;    
    vel[4] = time * .25;
    vel[5] = time * .05;    
    vel[5] = time * .05;    
    vel[6] = time * 3.05;
    
    vec3 orbits[7];
    orbits[0] = vec3(.43, .02,  .53);
    orbits[1] = vec3(.44, .024, .53);
    orbits[2] = vec3(.43, .022, .48);
    orbits[3] = vec3(.43, .025, .53);
    orbits[4] = vec3(.43, .03,  .53);
    orbits[5] = vec3(.40, .04,  .54);
    orbits[6] = vec3(.30, .08,  .60);
    
    vec3 posOffsets[7];
    posOffsets[0] = vec3(0., 0., -1.5) * rotation_matrix(vec3(sin(vel[0]), 0., cos(vel[0])), orbits[0]);
    posOffsets[1] = vec3(0., 0., -2.8) * rotation_matrix(vec3(sin(vel[1]), 0., cos(vel[1])), orbits[1]);
    posOffsets[2] = vec3(0., 0., -4.)  * rotation_matrix(vec3(sin(vel[2]), 0., cos(vel[2])), orbits[2]);
    posOffsets[3] = vec3(0., 0., -5.2) * rotation_matrix(vec3(sin(vel[3]), 0., cos(vel[3])), orbits[3]);
    posOffsets[4] = vec3(0., 0., -6.1) * rotation_matrix(vec3(sin(vel[4]), 0., cos(vel[4])), orbits[4]);
    posOffsets[5] = vec3(0., 0., -8.)  * rotation_matrix(vec3(sin(vel[5]), 0., cos(vel[5])), orbits[5]);
    posOffsets[6] = posOffsets[4] - vec3(0., 0., -.43) * rotation_matrix(vec3(sin(vel[6]), 0., cos(vel[6])), orbits[5]);
    
    
        vec2 res = vec2( sdSphere( pos-vec3(0.), 0.38 ), 1. );
        res = opU( res, vec2( sdSphere( pos - posOffsets[0], 0.04 ), 542.3 ) );
        res = opU( res, vec2( sdSphere( pos - posOffsets[1], 0.06 ), 4321. ) );
        res = opU( res, vec2( sdSphere( pos - posOffsets[2], 0.03 ), 1111. ) );
        res = opU( res, vec2( sdSphere( pos - posOffsets[3], 0.1  ), 53. ) );
        res = opU( res, vec2( sdSphere( pos - posOffsets[4], 0.15 ), 334. ) );
        res = opU( res, vec2( sdSphere( pos - posOffsets[5], 0.04 ), 14214. ) );
        res = opU( res, vec2( sdSphere( pos - posOffsets[6], 0.02 ),  32. ) );
    
    
    return res;
}

vec2 castRay( in vec3 ro, in vec3 rd, in float maxd )
{
    float precis = 0.01;
    float h=precis*2.0;
    float t = 0.0;
    float m = -1.0;
    for( int i=0; i<60; i++ )
    {
        if( abs(h)<precis||t>maxd ) continue;//break;
        t += h;
        vec2 res = map( ro+rd*t );
        h = res.x;
        m = res.y;
    }

    if( t>maxd ) m=-1.0;
    return vec2( t, m );
}

float atmosphere( in vec3 ro, in vec3 rd)
{
   
    float t = 0.1;
    float s = 1./32.;
    for( int i=0; i<32; i++ )
    {
            t += map(ro+rd*t)*.5;  
    }
    	
    return 1.-clamp(sqrt(t)/3.3, 0., 1.);
}

float flare( in vec3 ro, in vec3 rd)
{
   
    float s = 0.2;
    for( int i=0; i<32; i++ )
    {
	 s += length(ro+rd*s)*.2;  
    }
     s = 1.-pow(min(1.,s/12.), 32.) + pow(s/12., -16.) + (1.-min(1.,s/512.))*.005;
	
    return clamp(s, 0., 1.);
}

float softshadow( in vec3 ro, in vec3 rd, in float mint, in float maxt, in float k )
{
    float res = 1.0;
    float t = mint;
    for( int i=0; i<30; i++ )
    {
        if( t<maxt )
        {
        float h = map( ro + rd*t ).x;
        res = min( res, k*h/t );
        t += 0.02;
        }
    }
    return clamp( res, 0.0, 1.0 );

}

vec3 calcNormal( in vec3 pos )
{
    vec3 eps = vec3( 0.001, 0.0, 0.0 );
    vec3 nor = vec3(
        map(pos+eps.xyy).x - map(pos-eps.xyy).x,
        map(pos+eps.yxy).x - map(pos-eps.yxy).x,
        map(pos+eps.yyx).x - map(pos-eps.yyx).x );
    return normalize(nor);
}

float calcAO( in vec3 pos, in vec3 nor )
{
    float totao = 0.0;
    float sca = 1.0;
    for( int aoi=0; aoi<5; aoi++ )
    {
        float hr = 0.01 + 0.05*float(aoi);
        vec3 aopos =  nor * hr + pos;
        float dd = map( aopos ).x;
        totao += -(dd-hr)*sca;
        sca *= 0.75;
    }
    return clamp( 1.0 - 4.0*totao, 0.0, 1.0 );
}


vec3 render( in vec3 ro, in vec3 rd )
{ 
    vec3 col = vec3(0.0);
	float m = -1.;
    vec2 res = castRay(ro,rd,20.0);
    float t = res.x;
     m = res.y;
    
	//hacky stuff
    float atmos = atmosphere(ro, rd);
    vec3 sun = flare(ro, rd) * vec3(1., 1., .7);
    col += sin( vec3(0.05,0.08,0.10)*(m-1.0) );
    col += atmos;
	if(m == 1.){
		col = vec3(1., 1., .85) * (24.-sun) * t;
	}
    if( m>0. )
        {   
        vec3 pos = ro + t*rd;
        vec3 nor = calcNormal( pos );

        
        float ao = calcAO( pos, nor );
        
        vec3  lig = normalize(-pos);
        float amb = clamp( 0.5+0.5*nor.y, 0.0, 1.0 );
        float dif = clamp( dot( nor, lig ), 0.0, 1.0 );
        float bac = clamp( dot( nor, normalize(vec3(-lig.x,0.0,-lig.z))), 0.0, 1.0 )*clamp( 1.0-pos.y,0.0,1.0);

        float sh = 1.0;
        if( dif>0.02 ) { sh = softshadow( pos, lig, 0.02, 10.0, 7.0 ); dif *= sh; }

        vec3 brdf = vec3(0.0);
        brdf += 0.20*amb*vec3(0.10,0.11,0.13);
            brdf += 0.20*bac*vec3(0.15,0.15,0.15);
            brdf += 1.20*dif*vec3(1.00,0.90,0.70);

        float pp = clamp( dot( reflect(rd,nor), lig ), 0.0, 1.0 );
        float spe = sh*pow(pp,16.0);
        float fre = pow( clamp(1.0+dot(nor,rd),0.0,1.0), 2.0 );

        col = col*brdf + vec3(1.0)*col*spe + 0.2*fre*(0.5+0.5*col)-(atmos*sh)*.1; 
	}else{
		col = sun * vec3(2.3, 1.4, .65);
	}
	
	

    return vec3( clamp(col,0.0,1.0) );
}

void main( void )
{
    vec2 q = gl_FragCoord.xy/resolution.xy;
    vec2 p = -1.0+2.0*q;
    p.x *= resolution.x/resolution.y;
        vec2 mo = mouse.xy/resolution.xy;
         
    //float time = 15.0 + iGlobalTime;

    
    // animated camera  
    vec3 ro = vec3( -5.5+3.2*cos(0.1*time + 6.0*mo.x), 1.0 + 2.0*mo.y, 0.5 + 5.2*sin(0.1*time + 6.0*mo.x) );
    //vec3 ta = vec3( -0.5, -0.4, 0.5 );
     
    
    // mouselook camera;
    //vec3 ro = vec3(0., 1., -10.);
    vec2 mlook =  6.28*(mouse-.5);
    vec3 ta = vec3(mlook.x, mlook.y, 0.5 );
    
    
    // camera tx
    vec3 cw = normalize( ta-ro );
    vec3 cp = vec3( 0.0, 1.0, 0.0 );
    vec3 cu = normalize( cross(cw,cp) );
    vec3 cv = normalize( cross(cu,cw) );
    vec3 rd = normalize( p.x*cu + p.y*cv + 2.5*cw );

    
    vec3 col = render( ro, rd );

    col = sqrt( col );

    gl_FragColor=vec4( col, 1.0 );
}