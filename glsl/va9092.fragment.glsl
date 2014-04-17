// Thematica le 01/06/2013: drag mouse 3D
// credit: http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm

#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 centreCube=vec3(0.,0.,0.);

float sdPlane( vec3 p )
{
	return p.y+0.2;
}

float sdSphere( vec3 p, float s )
{
    return length(p)-s;
}

float sdCyl(vec3 p, float h,float r){
vec3 pa=abs(p);
float ra=length(pa.xz);
float k=(r<ra)? length(vec2(ra-r,pa.y-h)) : pa.y-h-0.001;
 return (pa.y<h)?(ra-r) : k;


}

float udRoundBox( vec3 p, vec3 b, float r )
{
  return length(max(abs(p)-b,0.05))-r;
}
float udBox( vec3 p, vec3 b )
{

  return length(max(abs(p-centreCube)-b,0.0));
}




//----------------------------------------------------------------------

float opS( float d1, float d2 )
{
    return max(-d2,d1);
}

float opU( float d1, float d2 )
{
	return (d1<d2) ? d1 : d2;
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

vec3 opTwist( vec3 p, float tc, float ts )
{
    float  c = cos(tc*p.y+ts);
    float  s = sin(tc*p.y+ts);
    mat2   m = mat2(c,-s,s,c);
    return vec3(m*p.xz,p.y);
}
vec3 opRot( vec3 p, float tc, float ts )
{
    float  c = cos(tc*p.y+ts);
    float  s = sin(tc*p.y+ts);
    mat3  mz = mat3(c,-s,0.0,s,c,0.0,0.0,0.0,1.0);//rotation autour de Z
    vec3 pt=mz*p+vec3(0.0,0.2,0.3);
    mat3 mx= mat3(1.0,0.0,0.0,0.0,c,-s,0.0,s,c);//rotation autour de X
    return mx*pt;
}
vec3 rotZ( vec3 p, float te )
{
    float  c = cos(te);
    float  s = sin(te);
    mat3  mz = mat3(c,-s,0.0,s,c,0.0,0.0,0.0,1.0);//rotation autour de Z
    return mz*p;
}
vec3 rotY( vec3 p, float te )
{
    float  c = cos(te);
    float  s = sin(te);
    mat3  my = mat3(c,0.0,-s , 0.0,1.0,0.0, s,0.0,c);//rotation autour de Y
    return my*p;
}
vec3 rotX( vec3 p, float te )
{
    float  c = cos(te);
    float  s = sin(te);
    mat3  my = mat3( 1.0,0.0,0.0, 0.0,c, -s, 0.0,s,c);//rotation autour de X
    return my*p;
}

                                                                                     

//----------------------------------------------------------------------

vec2 pointToObjects( in vec3 pos )
{	float r0= sdSphere(pos-vec3(0.0,0.2,1.0), 0.6 );	
	float r1= udBox( pos, vec3(0.1,0.6,0.1) );
	float r=min(r0,r1);
    	vec2 res = opU( vec2( sdPlane(   pos), 1.0 ), vec2(r, 2.0));	
   	return res;
}

vec2 castRay( in vec3 ro, in vec3 rd )
{
    float precis = 0.001;
    float h=1.0/60.0;
    float t = 0.0;
    float m = -1.0;
    for( int i=0; i<60; i++ )
    {
        if( abs(h)<precis||t>20.0 ) break;
        t += h;
        vec2 res = pointToObjects( ro+rd*t );
        h = res.x;
        m = res.y;
    }

    if( t>20.0 ) m=-1.0;
    return vec2( t, m );
}


float softshadow( in vec3 ro, in vec3 rd, in float mint, in float maxt, in float k )
{
	float res = 1.0;
    float dt = 0.02;
    float t = mint;
    for( int i=0; i<20; i++ )
    {
	if( t<maxt )
		{
        float h = pointToObjects( ro + rd*t ).x;
        res = min( res, k*h/t );
	t += 0.02;			
		}
    }
    return clamp( res, 0.0, 1.0 );

}
//--------------------------------------------------------------------------
vec3 calcNormal( in vec3 pos )
{
	vec3 eps = vec3( 0.001, 0.0, 0.0 );
	vec3 nor = vec3(
	pointToObjects(pos+eps.xyy).x - pointToObjects(pos-eps.xyy).x,
	pointToObjects(pos+eps.yxy).x - pointToObjects(pos-eps.yxy).x,
	pointToObjects(pos+eps.yyx).x - pointToObjects(pos-eps.yyx).x );
	return normalize(nor);
}
//---------------------------------------------------------------------------
float calcAO( in vec3 pos, in vec3 nor )// comme une  ombre de la lumiere ambiante
{
    float totao = 0.0;
    float sca = 1.0;// le scale est 1
    for( int aoi=0; aoi<2; aoi++ )
    {
        float hr = .05 + 0.1*float(aoi);
        vec3 aopos =  nor * hr + pos;
        float dd = pointToObjects( aopos ).x;
        totao += -(dd-hr)*sca;
        sca *= 0.75;// le scale est diminué
    }
    return clamp( 1.0 - 10.0*totao, 0.0, 1.0 );
}




vec3 render( in vec3 ro, in vec3 rd )
{ 
    vec3 col = vec3(0.0);
    vec2 res = castRay(ro,rd);
    float t = res.x;           
    float m = res.y; 
    if( m>-0.5 )
    {
        vec3 pos = ro + t*rd;
        vec3 nor = calcNormal( pos );

		col = vec3(0.2,0.3,0.8) + 0.02*( vec3(0.05,0.05,0.0)*(m-1.0) );//couleurs differenciées		
		float ao = calcAO( pos, nor );

		vec3 lig = normalize( vec3(-1.0, 0.5, 1.0) );         
		float amb = clamp( 0.5+0.5*nor.y, 0.0, 1.0 );   
		float dif = clamp( 1.5*dot( nor, lig ), 0.0, 1.0 );                              
		float bac = clamp( dot( nor, normalize(vec3(-lig.x,0.0,-lig.z))), 0.0, 1.0 )*clamp( 1.0-pos.y,0.0,1.0);

		float sh = 1.0;
		if( dif>0.02 ) { sh = softshadow( pos, lig, 0.12, 10.0, 7.0 ); dif *= sh; }   //l'ombre pas si douce

		vec3 brdf = vec3(0.0);
		brdf += 0.20*amb*vec3(0.10,0.11,0.13)*ao;
        		brdf += 0.20*bac*vec3(0.15,0.15,0.15)*ao;
        		brdf += 1.20*dif*vec3(1.00,0.90,0.70);

		float pp = clamp( dot( reflect(rd,nor), lig ), 0.0, 1.0 );
		float spe = sh*pow(pp,32.0);
		float fre = ao*pow( clamp(1.0+dot(nor,rd),0.0,1.0), 2.0 );

		col = col*brdf + vec3(1.0)*col*spe + 0.2*fre*(0.1+0.9*col);
		col = col*brdf  ;	
	}

	col *= exp( -0.01*t*t );
	return vec3( clamp(col,0.0,1.0) );
}

void main( void )
{
	vec2 p = 2.0*gl_FragCoord.xy/resolution.xy-1.0;	
	vec2 mous =vec2(2.0* mouse.x-1.0,2.0* mouse.y-1.0); 
	float tm = 15.0 + time;

	// camera	
	float angleCam=-0.7;
	float focale=2.5;
	vec3 ro = rotX(vec3( 0.0, 0.0 , -4.0),angleCam);
	vec3 rd=normalize(rotX(vec3(p.x,p.y,focale),angleCam));
	
	vec3 dm=normalize(rotX(vec3(mous.x,mous.y,focale),angleCam));
	float lambda=-ro.y/dm.y;
	centreCube=ro+lambda*dm;
	
	vec3 col = render( ro, rd);
	col = sqrt( col );
	gl_FragColor=vec4( col.x, col.y*0.8,2.0*col.z,1.0 );

}
