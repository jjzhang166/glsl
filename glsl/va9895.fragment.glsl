#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 sunVector = normalize(vec3(-0.9,0.9,-1.0));
	
// credit: iq/rgba
float hash( float n )
{
    return fract(sin(n)*43758.5453);
}


// credit: iq/rgba
float noise( in vec3 x )
{
    vec3 p = floor(x);
    vec3 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0 + 113.0*p.z;
    float res = mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
                        mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),
                    mix(mix( hash(n+113.0), hash(n+114.0),f.x),
                        mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
    return res;
}

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
	//return max(-(length(p)-1.1*s),length(max(abs (p)-vec3(0.05), 0.))-0.05);
    return length(p)-s;
}

vec2 map( in vec3 pos )
{
	float r = sdSphere(pos, 0.1);
//float r2 = sdSphere(pos-vec3(0.24, 0.0, 0.0), 0.1);	
    	//vec2 res = opU( vec2( sdPlane(     pos), 1.0 ), vec2(r, (abs(pos.y) * 200.0 + 700.0)));
    	vec2 res = opU( vec2( sdPlane(pos), 1.0 ), vec2(r, (abs(pos.y))));
	//vec2 res2 = opU(res, vec2(r2, abs(pos.y)));
    	return res;
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
    for( int i=0; i<200; i++ )
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

vec3 skyCol(in vec3 skyvector)
{
	vec3 skycol = 
		mix(
			vec3(0.02,0.03,0.2),
			vec3(0.4,0.6,0.9),
			pow(clamp(1.0-dot(skyvector,vec3(0.0,1.0,0.0)),0.0,1.0),2.0)
			);

	// scattering around the sun
	//skycol += vec3(1.0,0.9,0.3) * pow(clamp(dot(skyvector,sunVector),0.0,1.0),300.0) * 4.0;

	// sun disk
	skycol += vec3(1.0,0.9,0.6) * smoothstep(0.9998,0.99995,dot(skyvector,sunVector)) * 8.0;

	return skycol;
	
	
	
	/*vec3 c = vec3(0.0);
	
	float d = pow(clamp(dot(rd,vec3(0.0,1.0,0.0)),0.0,1.0),0.2);
	//float d2 = pow(clamp(dot(rd,vec3(0.0,-1.0,0.0)),0.0,1.0),0.05);
	
	c = mix(vec3(0.7,0.75,0.8),vec3(0.01,0.02,0.3),d);
	//c = mix(vec3(0.1,0.1,0.1),c,d2);
	return c;*/
}


vec3 render( in vec3 ro, in vec3 rd )
{ 
   vec3 col = skyCol(rd);
   vec2 res = castRay(ro,rd,20.0);
   float t = res.x;
   float m = res.y;

	vec3 lig = normalize( vec3(-0.5, 1.0, 0.2) );
	vec3 lcol = vec3(5.0);
	
	
   if( m>-0.5 )
   {
	   col = vec3(0.5);
      vec3 pos = ro + t*rd;
      vec3 nor = calcNormal( pos );
	   
	   
	float ao = calcAO( pos, nor );   
	vec3 ambc = skyCol(vec3(1,0.2,0.5));   	   
	col = ambc * ( 0.3 + 0.7 * ao) * 0.2;
	   
	// specular reflector
	   vec3 hv = (rd - lig) / length(rd-lig);
	   col += skyCol(reflect(rd,nor)) * 0.5;
	   
	  /* for(int i=0;i<50;i++){
		   vec3 n2 = normalize(nor *0.5 + vec3(hash(hash(rd.x)),hash(hash(rd.y)),hash(hash(rd.z)))*0.5);
		float spec = dot(hv,n2);
	  	col += skyCol(reflect(rd,n2)) * pow(spec,50.0);
	   }	*/	   
		
      //float ao = 1.0;//calcAO( pos, nor );

      
      //float amb = clamp( 0.5+0.5*nor.y, 0.0, 1.0 );
      //float dif = clamp( dot( nor, lig ), 0.0, 1.0 );
      //float bac = clamp( dot( nor, normalize(vec3(-lig.x,0.0,-lig.z))), 0.0, 1.0 )*clamp( 1.0-pos.y,0.0,1.0);

	//vec3 ambc = vec3(0.1,0.1,0.1);//skyCol(rd);   
	   
      //float sh = 1.0;
      //if( dif>0.02 ) { sh = softshadow( pos, lig, 0.02, 10.0, 7.0 ); dif *= sh; }

      //vec3 brdf = vec3(0.0);
      //brdf += 0.20*amb*vec3(0.90,0.0,0.0)*ao;
	  //brdf += ambc * 0.2 * ao;
      //brdf += 0.20*bac*vec3(0.15,0.15,0.15)*ao;
      //brdf += 1.20*dif*vec3(1.00,0.90,0.70);

      //float pp = clamp( dot( reflect(rd,nor), lig ), 0.0, 1.0 );
      //float spe = sh*pow(pp,16.0);
      //float fre = ao*pow( clamp(1.0+dot(nor,rd),0.0,1.0), 2.0 );

      //col = col*brdf + vec3(1.0)*col*spe + 0.2*fre*(0.5+0.5*col);
      //col = col*brdf + 0.2*fre*(0.5+0.5*col);
	
	   
   }

   
   //col *= exp( -0.01*t*t );


   return col; //vec3( clamp(col,0.0,1.0) );
}

void main( void ) {

   vec2 q = gl_FragCoord.xy/resolution.xy;
   vec2 p = -1.0+2.0*q;
   p.x *= resolution.x/resolution.y;
	
   // camera	
   vec3 ro = vec3( mouse.x, (mouse.y - 0.1) * 0.6, mouse.x
		 );	
   //vec3 ro = vec3( 0.5, 0.5, 1.0);	
	vec3 ta = vec3( 0.0, 0.1, 0.0 );
	
   // camera tx
   vec3 cw = normalize( ta-ro );
   vec3 cp = vec3( 0.0, 1.0, 0.0 );
   vec3 cu = normalize( cross(cw,cp) );
   vec3 cv = normalize( cross(cu,cw) );
   vec3 rd = normalize( p.x*cu + p.y*cv + 2.5*cw );

   vec3 col = render( ro, rd );

   //col = sqrt( col );
   //col = sqrt( col );
	col = col / (vec3(1.0) + col);
   col = pow(col, vec3(1.0 / 2.2)); //gamma

   gl_FragColor=vec4( col, 1.0 );
}