
// point de départ: http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
//  distance :  thematica

#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


// point de départ: http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
//  bidouille :  thematica



float pointToBoxVide( vec3 p, vec3 b, float r )
	{	vec3 pa=abs(p);
		float dy= length( vec3( b.x-pa.x  ,  b.z-pa.z,  (-b.y+pa.y)*step(b.y,pa.y) ))-r;
		float dx= length( vec3( b.y-pa.y  ,  b.z-pa.z,  (-b.x+pa.x)*step(b.x,pa.x) ))-r;
		float dz= length( vec3 (b.x-pa.x  ,  b.y-pa.y,  (-b.z+pa.z)*step(b.z,pa.z) ))-r;
		return min(dx,min(dy,dz));
	}

vec3 rotZ( vec3 p, float tc,vec3 centre,float r1)
	{			
		vec3 ver=vec3(0.0,r1,0.0);
		float  c = cos(tc);
		float  s = sin(tc);
		mat3   mz = mat3(c,-s,0.0,s,c,0.0,0.0,0.0,1.0);
		mat3 mx=mat3(1.0,0.0,0.0,0.0,c,-s,0.0,s,c);
 	  return  (mz*mx)*(p-ver) + centre;
 	  }


//----------------------------------------------------------------------

float render( vec3 org, vec3 dir){
	vec3 trans=vec3(0.0,0.4,0.0);
	float lambda = 0.0;
	vec3 pos= org ;
	float lamb=1.0;
for(int  compte=0; compte<100; compte++){

	vec3 tw=rotZ(pos,  time, trans,0.4);
	lamb= pointToBoxVide(tw,vec3(0.6+0.4*cos(time),0.6+0.3*sin(time),0.7+0.2*sin(0.2*time)),0.04);
	lambda+=lamb;
	pos=org+lambda*dir;
	if(lamb<1.0e-6) break;
}

vec3 v=normalize(vec3(0.10*cos(time),0.2*sin(time),7.0*sin(0.5*time)));
	// la couleur suivant en fonction de l'intersection
	if (abs(lamb)>1.0e-6) 
		return 0.0; 
	else
		return  abs(lambda*dot(v, pos));
}

void main( void )
{
	vec2 q = gl_FragCoord.xy/resolution.xy;
	vec2 p = -1.0+2.0*q;
	p.x *= resolution.x/resolution.y;
	// camera	
	vec3 oeil = vec3( 0.0, 0.5 ,7.0);		
	// camera tx
	vec3 cw = normalize(-oeil );
	vec3 cp = vec3( 0.0, 1.0, 0.0 );
	vec3 cu = normalize( cross(cw,cp) );
	vec3 cv = normalize( cross(cu,cw) );
	vec3 dirRayon = normalize( p.x*cu + p.y*cv + 2.5*cw );
	//dirRayon est exprimé dans le repere absolu ,ce qui est indispensable pour les rotations
	//mais il est construit dans  le repère écran-camera
	
	float  coul =0.1* render( oeil, dirRayon );	
	gl_FragColor=vec4(coul,coul,1.0-coul,1.0);
}