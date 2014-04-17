//CubesSurTore
// Thematica : Circulation sur un Tore
// Credit: http://glsl.heroku.com/e#8774.0 

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const	int nn=4;
const float gr=0.3;
const float pr=0.2;
const  float pi=3.1415926;
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




float pointToBox(vec3 p, float c){
 return length(max(abs(p)-c,0.0)); 
}
float pointToTore( vec3 p){
	
	return length(vec2(length(p.xz)-gr,p.y))-pr;


}


vec4 pointToScene( vec3 p )
{	                     
float q=pi*2.0/float(nn);
vec4 dists;
 dists.w= pointToTore(p);	 
 float i=1.0; dists.x=pointToBox(rotZ(rotY(p,time+q*i)-vec3(gr,0.0,0.0),2.0*time+2.0*q*i)-vec3(0.0,0.04+pr,0.0), 0.04); 
i+=1.0;       dists.y=pointToBox(rotZ(rotY(p,time+q*i)-vec3(gr,0.0,0.0),2.0*time+2.0*q*i)-vec3(0.0,0.04+pr,0.0), 0.04); 
i+=1.0;       dists.z=pointToBox(rotZ(rotY(p,time+q*i)-vec3(gr,0.0,0.0),2.0*time+2.0*q*i)-vec3(0.0,0.04+pr,0.0), 0.04); 


    return dists;  
}

vec2 map( in vec3 pos )
{	
	vec4 res = pointToScene(pos);
	float d=30.0, m=-1.0;
	if (res.w<d)  {d=res.w;  m=0.0;}
  	if(res.x<d)    {d=res.x;   m=1.0;}
  	if(res.y<d)    {d=res.y;   m=2.0;}
  	if(res.z<d)    {d=res.z;   m=3.0;}
 
    	return vec2(d,m);
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


vec3 render( in vec3 ro, in vec3 rd )
{ 
   vec3 col = vec3(0.0);
   vec2 res = castRay(ro,rd,20.0);
    float t = res.x;
   float m = res.y;
   if( m<-0.5 )  
  	 {col=vec3(0.5); } 
   else
  	 {if(abs(m)<0.01)
  	 	{
  	 	vec3 pos = ro + t*rd;
    
  	 	float alpha=atan(pos.z,pos.x);
  	 	float beta=atan(pos.y,(sin(alpha)+cos(alpha))*pos.y-gr);
  	 	col=vec3(step(mod(alpha+beta,pi/6.0),pi/12.0));
  	 	vec3 no= calcNormal(pos);
  	 	col=dot(col,no)*no;
  	 	}
  	 	else
  	 	{
  	 	col=vec3(cos(pi*m/6.0),sin(pi*m/6.0),1.0-sin(pi*m/6.0)); 
  	 	vec3 np= calcNormal(ro+t*rd);
  	 	col=dot(col,np)*np;
  	 	}
  	 }
   return vec3(sqrt(clamp(col,0.0,1.0) ));
}
  

  

void main( void ) {

   vec2 q = gl_FragCoord.xy/resolution.xy;
   vec2 p = -1.0+2.0*q;
   p.x *= resolution.x/resolution.y;
	
   // camera	
   vec3 ro = vec3( mouse.x, mouse.y/2.0+0.7 , mouse.x);	
   vec3 ta = vec3( 0.0, 0.0, 0.0 );
	
   // camera tx
   vec3 cw = normalize( ta-ro );
   vec3 cp = vec3( 0.0, 1.0, 0.0 );
   vec3 cu = normalize( cross(cw,cp) );
   vec3 cv = normalize( cross(cu,cw) );
   vec3 rd = normalize( p.x*cu + p.y*cv + 2.5*cw );

   vec3 col = render( ro, rd );
   gl_FragColor=vec4( col, 1.0 );

	}
