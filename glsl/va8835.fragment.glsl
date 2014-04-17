//  Thematica : Cubes de l'espace en abime


#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

float pointToGrille( vec3 pp,float b, float r )

	{	vec3 p=abs(pp);
		vec3 pa=mod(p,2.0*b)-b;
		
		//float dy= length( vec2(b - length(pa.xz), pa.y));
		//float dz= length( vec2(b - length(pa.xy), pa.z));
		//float dx= length( vec2(b - length(pa.xz), pa.x));
		float ddy= length( vec3( pa.x  ,  pa.z,  pa.y*step(0.0,pa.y) ));
		float ddz= length( vec3(pa.x   , pa.y ,  pa.z*step(0.0,pa.z) ));
		float ddx= length( vec3(pa.z   , pa.y ,  pa.x*step(0.0,pa.x) ));
		return min( ddx,min(ddy,ddz)) -r;
		
	}	
	

vec3 rotor( vec3 p)
	{	float co=time*0.1;				
		float  c = cos(co);
		float  s = sin(co);
		mat3   mz = mat3(c,-s,0.0,s,c,0.0,0.0,0.0,1.0);
		mat3 mx=mat3(1.0,0.0,0.0, 0.0,c,-s, 0.0,s,c);
		mat3 m=mz*mx;
 	  return  p*m;
 	  }


//----------------------------------------------------------------------

float render( vec3 org, vec3 dir){
	float lambda = 0.0;
	vec3 pos= org ;
	float lamb=100.0;
	float couleur=0.0;
for(int  i=0; i<100; i++){	
	lamb= pointToGrille(pos,12.0,1.8);
	lambda+=lamb;
	pos=org+lambda*dir;
	couleur+=0.01;
	if(abs(lamb)<1.0e-4) break;
}
		return clamp(couleur*1.3,0.0,1.0);
}

//----------------------------------------------------------------------
void main( void )
{
	vec2 p= gl_FragCoord.xy/resolution.xy -0.5;
	p.x*=resolution.x/resolution.y;
					// camera	
	vec3 oeil=vec3(0.0,0.0,-1.62);		
					// rotation de la camera	
	 oeil=rotor(oeil);
	 				//direction
	vec3 dirRayon=normalize(rotor(vec3(p.x,p.y,1.60)));
					//calcul de la couleur
	float  coul = render( oeil+12.0*dirRayon, dirRayon );
	vec3 color=vec3(1.0-coul,coul,1.0-coul);
	color=cross(color,dirRayon) ;
	gl_FragColor=vec4(color,1.0);
}