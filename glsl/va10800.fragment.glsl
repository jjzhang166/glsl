#define PROCESSING_COLOR_SHADER
// credit: http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm

#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float deltaT=1.6;
const float hTuyau=0.8;
const float TPI=6.28;
vec3 colcontact=vec3(0.,1.0,0.);

float rTuyau=0.15;
float angleCamX=0.0,angleCamY=0.0;





//----------------------------------------------------------------------

float opS( float d1, float d2 )
{
    return max(-d2,d1);
}
vec4 opS( vec4 d1, vec4 d2 )
{
    return vec4(max(-d2.x,d1.x),d2.yzw);
}

float opU( float d1, float d2 )
{
	return (d1<d2) ? d1 : d2;
}


vec2 opU( vec2 d1, vec2 d2 )
{
	return (d1.x<d2.x) ? d1 : d2;
}

vec4 opU( vec4 d1, vec4 d2 )
{
	return (d1.x<d2.x) ? d1 : d2;
}

vec3 opRep( vec3 p, vec3 c )
{
    return mod(p,c)-0.5*c;
}

vec3 opTwist( vec3 p )
{
    float  c = cos(1.2*p.y+1.0);
    float  s = sin(1.2*p.y+1.0);
    mat2   m = mat2(c,-s,s,c);
    vec2 tr=m*p.xz;
    return vec3(tr.x,p.y,tr.y);
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

  


float udBox( vec3 p, vec3 b )
{    p=opTwist(p);
  return length(max(abs(p)-b,0.0));
}


//----------------------------------------------------------------------

vec4 pointToObjects( in vec3 pos ){
	float j=0.0;
	vec4 res=vec4( udBox(pos ,vec3(rTuyau,hTuyau,rTuyau)),colcontact);
	for(int i=0; i<6;i++){
	float h=hTuyau*abs(cos(time+TPI/6.0*j));
	vec3 centre=vec3( 0.5*cos(TPI/6.0*j),h,0.5*sin(TPI/6.0*j) );
	j+=1.0;
	res=opU(res,vec4( udBox(pos-centre,vec3(rTuyau,h,rTuyau)),colcontact));
}	
   	return res;
}



vec4 castRay( in vec3 ro, in vec3 rd )
{
    float precis = 0.01;
    float h=0.01;
    float t = 0.0;
   vec3 m = vec3(0.,0.,0.);
    for( int i=0; i<10; i++ )
    {
        if( abs(h)<precis||t>40.0 ) break;
        t += h;
        vec4 res = pointToObjects( ro+rd*t );
        h = res.x;
        m = res.yzw;
    }

    if( t>5.0 ) m=vec3(abs(cos(t)),abs(sin(t)),5.0/t);
    return vec4( t, m );
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




vec3 render( in vec3 ro, in vec3 rd )
{ 
    vec3 col = vec3(0.,0.,0.);
    vec4 res = castRay(ro,rd);
    float t = res.x;           
   vec3 m = res.yzw; 

 
        vec3 pos = ro + t*rd;
       
        vec3 nor = calcNormal( pos );

		col = m;		
		vec3 dirlum = rotY(rotX(normalize( vec3(0.5, -0.3, 0.3) ),angleCamX*0.6),angleCamY*0.5);         
		float dif = dot( nor, dirlum );                              
        		vec3 colocale = dif*dirlum;		
		
		col = col*(colocale + pow( dot(nor,rd), 3.0 ));
		col = col*colocale*3.0  ;	
	col *= t*t;
	return vec3( clamp(col,0.0,1.0) );
}

void main( void )
{
	
	vec2 p = 2.0*gl_FragCoord.xy/resolution.xy-1.0;
	p.y*=resolution.y/resolution.x;
	
	
	
	// camera	
	 angleCamX=time*0.2;
	 angleCamY=2.0+time*0.2;
	float focale=8.0;
		
	vec3 ro = rotY(rotX(vec3( 0.0, 0.0 , -8.0),angleCamX),angleCamY);
	vec3 rd=normalize(rotY(rotX(vec3(p.x,p.y,focale),angleCamX),angleCamY));	
	vec3 col = render( ro, rd);
	col = sqrt( col );
	gl_FragColor=vec4( col.x, col.y*0.8,2.0*col.z,1.0 );

}
