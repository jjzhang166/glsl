//Thematica: coude

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


const float pi=3.14159;
const float pr=1.3;
const float gr=1.5;
const float haut=0.8;

vec3 rotX(vec3 v, float angle)
{
    float s = sin(angle);
    float c = cos(angle);
    mat3 mx=mat3(1.0,0.0,0.0,0.0,c,-s,0.0,s,c);
   return mx*v;
}

vec3 rotY(vec3 v, float angle)
{
    float s = sin(angle);
    float c = cos(angle);
    mat3 my=mat3(c,0.0,-s,0.0,1.0,0.0,s,0.0,c);
   return my*v;
}

vec3 rotZ(vec3 v, float angle)
{
    float s = sin(angle);
    float c = cos(angle);
    mat3 mz=mat3(c,-s,0.0,  s,c,0.0,  0.0,0.0,1.0);
   return mz*v;
}

vec3 rotate(vec3 v,vec2 a){
    float s = sin(a.x);
    float c = cos(a.x);
    mat3  mx=mat3(1.0,0.0,0.0,0.0,c,-s,0.0,s,c);
    s= sin(a.y);
    c = cos(a.y);
    mat3  my=mat3(c,0.0,-s,0.0,1.0,0.0,s,0.0,c);
    return v*mx*my;}

float pointToTore( vec3 p){	
	return length(vec2(length(p.xz)-gr,p.y))-pr;
}

float pointToSphere( vec3 p, float r )
{
return length(p)-r;
}
float pointToBoxVide( vec3 p, vec3 b, float r )
	{	vec3 pa=abs(p);
		float dy= length( vec3( b.x-pa.x  ,  b.z-pa.z,  (-b.y+pa.y)*step(b.y,pa.y) ))-r;
		float dx= length( vec3( b.y-pa.y  ,  b.z-pa.z,  (-b.x+pa.x)*step(b.x,pa.x) ))-r;
		float dz= length( vec3 (b.x-pa.x  ,  b.y-pa.y,  (-b.z+pa.z)*step(b.z,pa.z) ))-r;
		return min(dx,min(dy,dz));
	}
float sdBox( vec3 p, vec3 b )
{
  vec3 d = abs(p) - b;
  return min(max(d.x,max(d.y,d.z)),0.0) +
         length(max(d,0.0));
}

float sdCyl(vec3 p, float h,float r){
vec3 pa=abs(p);
float ra=length(pa.xz);
float k=(r<ra)? length(vec2(ra-r,pa.y-h)) : pa.y-h-0.001;
 return (pa.y<h)?(ra-r) : k;


}



vec2 map( in vec3 pos )
{	
	vec3 centre=vec3(0.8-0.6*sin(time),-haut,0.0);
	vec3 vr=rotZ(pos-centre,-atan(pos.y,0.8-0.6*sin(time)))+centre;
	float r2= sdCyl(vr, haut,0.5*haut);
	float r1=pointToBoxVide(pos,vec3(2.0,1.0,1.0),0.05);
	return  vec2(min(r1,r2),1.0);
    	
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


vec2 castRay( in vec3 ro, in vec3 rd )
{

    float precis = 0.001;
    float lamb=precis*2.0;
    float lambda = 0.0;
    float m = -1.0;
    for( int i=0; i<60; i++ )
    {
        if( abs(lamb)<precis || lambda>20.0 ) break;
       lambda +=lamb;
	    vec2 res = map( ro+rd*lambda);
       lamb = res.x;
        m = res.y;
    }

    if( lambda>20.0 ) m=-1.0;
    return vec2( lambda, m );
}


vec3 render( in vec3 ro, in vec3 rd )
{ 
   vec2 res = castRay(ro,rd);
   float t = res.x;
   float m = res.y;
   vec3 col=vec3(0.0);
   if( m>-0.5 )
   {
      vec3 pos = ro + t*rd;
    
      float alpha=atan(pos.z,pos.x);
      float beta=atan(pos.y,(sin(alpha)+cos(alpha))*pos.y-gr);
     col=vec3(step(mod(alpha+beta,pi/6.0),pi/12.0));
     vec3 no= calcNormal(pos);
     col=dot(col,no)*no;
   }
   else
   {col=vec3(0.2,0.1,1.0); }   
   return vec3(clamp(col,0.0,1.0));
}


void main( void ) {


   vec2 q = gl_FragCoord.xy/resolution.xy;
   vec2 p = -1.0+2.0*q;
   p.x *= resolution.x/resolution.y;
	
   // camera
   vec2 angles=vec2(0.2*pi,(-mouse.x+0.5)*pi);
   vec3 ro =rotate(vec3(0.0,0.0,-3.5),angles);
  
	

  float focale=(mouse.y+0.5)*pi;
   vec3 rd = normalize(rotate(vec3(p,focale),angles ));
   vec3 col = render( ro, rd);
   gl_FragColor=vec4( col, 1.0 );

}
