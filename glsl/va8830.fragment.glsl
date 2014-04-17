//  Thematica :Cube primaire



#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
uniform vec2 resolution;
	

float pToCube(vec3 p, float c){
		vec3 pa=abs(p)-c;
		return length(max(pa,0.0));
		

}	

vec3 rotor( vec3 p)
	{	float co=0.2+time;				
		float  c = cos(co);
		float  s = sin(co);
		mat3   mz = mat3(c,-s,0.0,s,c,0.0,0.0,0.0,1.0);
		mat3 mx=mat3(1.0,0.0,0.0, 0.0,c,-s, 0.0,s,c);
		mat3 my=mat3( c,0.0,-s,0.0,1.0,0.0, s,0.0,c);
		mat3 m=mz*mx*my;
 	  return  p*m;
 	  }


//----------------------------------------------------------------------

float render( vec3 org, vec3 dir){
	float lambda = 0.0;
	vec3 pos= org ;
	float lamb=100.0;
	float couleur=0.0;
for(int  i=0; i<100; i++){	
	lamb= pToCube(pos,0.35);
	lambda+=lamb;
	pos=org+lambda*dir;
	couleur+=0.01;
	if(abs(lamb)<1.0e-3  || lambda>30.0) break;
}	
		return clamp(couleur*1.3,0.0,1.0);
}

//----------------------------------------------------------------------
void main( void )
{
	vec2 p= (gl_FragCoord.xy/resolution.xy)-0.5;
	p.x*=resolution.x/resolution.y;
	
	
					// camera	
	vec3 oeil=vec3(0.0,0.0,-3.62);		
					// rotation de la camera	
	 oeil=rotor(oeil);
	 				//direction
	vec3 dirRayon=normalize(rotor(vec3(p.x,p.y,2.60)));
					//calcul de la couleur
	float  coul = render( oeil, dirRayon );
	vec3 color=vec3(coul,1.0-coul,coul);
	color=cross(color,dirRayon)+dot(dirRayon,vec3(0.2,0.1,0.8));
	gl_FragColor=vec4(color,1.0);
}