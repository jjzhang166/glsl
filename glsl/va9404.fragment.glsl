
// credit: http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm

#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 colcontact=vec3(0.,1.0,0.);

float sdPlane( vec3 p )
	{
	return p.y+0.2;
	}


float xyzCyl(vec3 p, float h,float r){
vec3 pa=abs(p);
float ra=length(pa.yz);
float k=(r<ra)? length(vec2(ra-r,pa.x-h)) : pa.x-h-0.001;
 return (pa.x<h)?(ra-r) : k;


}
float zyxCyl(vec3 p, float h,float r){
vec3 pa=abs(p);
float ra=length(pa.yx);
float k=(r<ra)? length(vec2(ra-r,pa.z-h)) : pa.z-h-0.001;
 return (pa.z<h)?(ra-r) : k;


}

float udRoundBox( vec3 p, vec3 b, float r )
{
  return length(max(abs(p)-b,0.05))-r;
}

float udBox( vec3 p, vec3 b )
{
  return length(max(abs(p)-b,0.0));
}


float pointToTore(vec3 p,float grr,float r){
	vec2 v=vec2( length(p.xz)-grr,p.y);
	return length(v)-r;
}





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


vec4 pointToObjects( in vec3 pos ){
	vec4 r3=vec4(pointToTore(pos,4.0,.05),1.,0.,0.);
	vec4 r0=vec4(xyzCyl(pos-vec3(0.,0.,7.0),10.0,0.1),0.,1.0,0.);
	vec4 r4=opU(r3,r0);
	vec4 r1= vec4(zyxCyl( pos-vec3(0.,0.,3.5) ,3.5,0.05 ),1.0,1.0,0.);
	vec4 r5=opU(r4,r1);
    	vec4 r6 = opU( vec4( sdPlane(pos-vec3(0.,-0.2,0.)), 1.0,0.,1.0 ), r5);
	vec4 r7=vec4(pointToTore(pos-vec3(0.,0.,8.0/7.0),8./7.,.1),1.,0.,0.);
	vec4 r8=opU(r6,r7);
	vec4 r9=vec4( zyxCyl(  rotY(pos-vec3(-4.*cos(time),0.,3.5),-atan(-8.*cos(time),7.)),length(vec2(4.*cos(time),3.5)),0.05)   ,0.,1.0,0.);
	vec4 r10=opU(r8,r9);
	vec4 r11=vec4(pointToTore(pos-vec3(-4.*cos(time),0.,65./14.), length(vec2(4.0*cos(time),33.0/14.0)),0.05),1.,0.,0.);
	vec4 r12=opU(r10,r11);	
   	return r12;
}

vec4 castRay( in vec3 ro, in vec3 rd )
{
    float precis = 0.001;
    float h=1.0/60.0;
    float t = 0.0;
   vec3 m = vec3(0.,0.,0.);
    for( int i=0; i<60; i++ )
    {
        if( abs(h)<precis||t>20.0 ) break;
        t += h;
        vec4 res = pointToObjects( ro+rd*t );
        h = res.x;
        m = res.yzw;
    }

    if( t>20.0 ) m=vec3(0.,0.,0.);
    return vec4( t, m );
}


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
    
   	 vec4 res = castRay(ro,rd);
   	 vec3 pos = ro +  res.x*rd;
   	 vec3 nor = calcNormal( pos );	
	return clamp(nor*dot (res.yzw,nor),0.,1.);
}

void main(  )
{	
	vec2 p = 2.0*gl_FragCoord.xy/resolution.xy-1.0;	
	p.y*=resolution.y/resolution.x;
	
	vec2 mous =vec2(2.0* mouse.x-1.0,2.0* mouse.y-1.0); 
	
	// camera	
	float angleCamX=-1.2+0.5*cos(time);
	float angleCamY=0.3*time;
	float focale=0.4;
	vec3 ro =rotY( rotX(vec3( 0.0, 0.0 , -10.0),angleCamX),angleCamY);
	vec3 rd=normalize(rotY(rotX(vec3(p.x,p.y,focale),angleCamX),angleCamY));
	
	vec3 col = render( ro, rd);
	gl_FragColor=vec4( col,1.0 );

}
