
//CubesSurTore
// Thematica : Circulation sur un Tore
// Credit: http://glsl.heroku.com/e#8774.0 et d'autres!

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const	int nn=3;
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



float pointToTore( vec3 p, float gr, float r){
	
	return length(vec2(length(p.xz)-gr,p.y))-r;


}
float pointToBox(vec3 p, float c){
 return length(max(abs(p)-c,0.0)); 
}



float sdTore( vec3 p )
{

	
float q=6.28318/float(nn);
   float tor= length(vec2(length(p.xz)-gr,p.y))-pr;
   float res=tor;
   float i=0.0;
  for(int j=0;j<nn;j++){ 
	 
float cb=pointToBox(rotZ(rotY(p,time+q*i)-vec3(gr,0.0,0.0),2.0*time+2.0*q*i)-vec3(0.0,0.04+pr,0.0), 0.04); 
res=min(res,cb);
i+=1.0;
} 
    return res;  
}

vec2 map( in vec3 pos )
{	
	float r = sdTore(pos);	
    	return vec2(r,1.0);
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
   {col=vec3(0.5); }   
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
