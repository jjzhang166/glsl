#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 opU( vec2 d1, vec2 d2 )
{
	return (d1.x<d2.x) ? d1 : d2;
}

float sdPlane( vec3 p )
{
	return p.y+0.1;
}

float sdSphere( vec3 p, float s )
{
	return max(-(length(p)-1.1*s),length(max(abs (p)-vec3(0.05), 0.))-0.05);
   // return length(p)-s;
}

vec2 map( in vec3 pos )
{
	float r = sdSphere(pos, 0.1);
float r2 = sdSphere(pos-vec3(0.24, 0.0, 0.0), 0.1);	
    	//vec2 res = opU( vec2( sdPlane(     pos), 1.0 ), vec2(r, (abs(pos.y) * 200.0 + 700.0)));
    	vec2 res = opU( vec2( sdPlane(pos), 1.0 ), vec2(r, (abs(pos.y))));
	vec2 res2 = opU(res, vec2(r2, abs(pos.y)));
    	return res2;
}

vec3 calcNormal( in vec3 pos)
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

vec2 castRay( in vec3 ro, in vec3 rd, in float maxd )
{
    float precis = 0.001;
    float h=precis*2.0;
    float t = 0.0;
    float m = -1.0;
    for( int i=0; i<60; i++ )
    {
        if( abs(h)<precis||t>maxd ) break;
        t += h;
	    vec2 res = map( ro+rd*t );
        h = res.x;
	    m = res.y;
    }

    if( t>maxd ) m=-1.0;
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
        float h = map( ro + rd*t ).x;
        res = min( res, k*h/t );

	t += 0.02;
			
		}
    }
    return clamp( res, 0.0, 1.0 );

}


vec3 render( in vec3 ro, in vec3 rd )
{ 
   vec3 col = vec3(0.3);
   vec2 res = castRay(ro,rd,20.0);
   float t = res.x;
   float m = res.y;
	
   if( m>-0.5 )
   {
      vec3 pos = ro + t*rd;
      vec3 nor = calcNormal( pos );

      //col = vec3(0.6) + 0.4*sin( vec3(0.05,0.08,0.10)*(m-1.0)*cos(time)*0.09 );
		
      float ao = calcAO( pos, nor );

      vec3 lig = normalize( vec3(-1.0, 1.0, 1.0) );
      float amb = clamp( 0.5+0.5*nor.y, 0.0, 1.0 );
      float dif = clamp( dot( nor, lig ), 0.0, 1.0 );
      float bac = clamp( dot( nor, normalize(vec3(-lig.x,0.0,-lig.z))), 0.0, 1.0 )*clamp( 1.0-pos.y,0.0,1.0);

      float sh = 1.0;
      if( dif>0.02 ) { sh = softshadow( pos, lig, 0.02, 10.0, 7.0 ); dif *= sh; }

      vec3 brdf = vec3(0.0);
      brdf += 0.20*amb*vec3(0.10,0.11,0.13)*ao;
      brdf += 0.20*bac*vec3(0.15,0.15,0.15)*ao;
      brdf += 1.20*dif*vec3(1.00,0.90,0.70);

      float pp = clamp( dot( reflect(rd,nor), lig ), 0.0, 1.0 );
      float spe = sh*pow(pp,16.0);
      float fre = ao*pow( clamp(1.0+dot(nor,rd),0.0,1.0), 2.0 );

      //col = col*brdf + vec3(1.0)*col*spe + 0.2*fre*(0.5+0.5*col);
      col = col*brdf + 0.2*fre*(0.5+0.5*col);
	   
   }

   
   col *= exp( -0.01*t*t );


   return vec3( clamp(col,0.0,1.0) );
}

void main( void ) {

   vec2 q = gl_FragCoord.xy/resolution.xy;
   vec2 p = -1.0+2.0*q;
   p.x *= resolution.x/resolution.y;
	
   // camera	
   //vec3 ro = vec3( mouse.x, mouse.y , mouse.x);	
   vec3 ro = vec3( 0.5, 0.5, 1.0);	
	vec3 ta = vec3( 0.0, 0.0, 0.0 );
	
   // camera tx
   vec3 cw = normalize( ta-ro );
   vec3 cp = vec3( 0.0, 1.0, 0.0 );
   vec3 cu = normalize( cross(cw,cp) );
   vec3 cv = normalize( cross(cu,cw) );
   vec3 rd = normalize( p.x*cu + p.y*cv + 2.5*cw );

   vec3 col = render( ro, rd );

   col = sqrt( col );
   col = sqrt( col );

   gl_FragColor=vec4( col, 1.0 );
}