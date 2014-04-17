
// Thematica : Interpolation
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;



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
vec3 rot(vec3 v){
	float ax=	(-mouse.y+0.5)*3.14159;			
	float ay=	(mouse.x-0.5)*3.14159;
	return rotY( rotX(v,ax),ay);	
	
}


float pointToCercles1( vec3 pp,float b, float r )

	{	vec3 p=abs(pp);
		vec3 pa=p-b;		
		float dy= length( vec2(b - length(pa.xz), pa.y));
		float dz= length( vec2(b - length(pa.xy), pa.z));
		float dx= length( vec2(b - length(pa.yz), pa.x));		
		return min(min(dx,dy),dz)-r;
		
	}	
float pointToCercles2( vec3 pp,float b, float r )

	{	vec3 p=abs(pp);
		vec3 pa=p-b;		
		float dy= length( vec2(b - length(pp.xz), pa.y));
		float dz= length( vec2(b - length(pp.xy), pa.z));
		float dx= length( vec2(b - length(pp.yz), pa.x));		
		return min(min(dx,dy),dz)-r;
		
	}	
float pointToBoxVide1( vec3 pp, float b, float r )
	{
		vec3 p=abs(pp);
		vec3 pa=p-b;
		float dy= length( vec3( b-p.x  ,  b-p.z,  (-b+pa.y)*step(b,pa.y) ))-r;
		float dx= length( vec3( b-p.y  ,  b-p.z,  (-b+pa.x)*step(b,pa.x) ))-r;
		float dz= length( vec3 (b-p.x  ,  b-p.y,  (-b+pa.z)*step(b,pa.z) ))-r;
		return min(dx,min(dy,dz));
	}


float pointToBoxVide( vec3 p, vec3 b, float r )
	{	vec3 pa=abs(p);
		float dy= length( vec3( b.x-pa.x  ,  b.z-pa.z,  (-b.y+pa.y)*step(b.y,pa.y) ))-r;
		float dx= length( vec3( b.y-pa.y  ,  b.z-pa.z,  (-b.x+pa.x)*step(b.x,pa.x) ))-r;
		float dz= length( vec3 (b.x-pa.x  ,  b.y-pa.y,  (-b.z+pa.z)*step(b.z,pa.z) ))-r;
		return min(dx,min(dy,dz));
	}


float distMarching( vec3 p)
	{
		float cercles2=pointToCercles1(p,0.18,0.06);
		float cercles1=pointToBoxVide1(p,0.18,0.06);
		return mix(cercles2,cercles1,smoothstep(0.0,1.0,abs(sin(time))));
	}

vec3 pNormale(vec3 p) 
{
	float ep2 = 0.01;
	return normalize( vec3(
		distMarching(p+vec3(ep2,0,0)) - distMarching(p-vec3(ep2,0,0)),
		distMarching(p+vec3(0,ep2,0)) - distMarching(p-vec3(0,ep2,0)),
		distMarching(p+vec3(0,0,ep2)) - distMarching(p-vec3(0,0,ep2))));
}

					//----------------------------------------------------
void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy - 0.5;	
	position.x *= resolution.x / resolution.y;
	
					//la camera en perspective cylindrique
	
	 vec3 posRayon=vec3 (position.x, position.y, -1.0); //1.0 est la distance de l'oeil à l'ecran
	 posRayon =rot(posRayon);
	 vec3 raydir=rot(vec3(0,0,1));
	   			
					//Sphere Marching 
	
	float lamb=0.0;
	float lambda = 0.0;
	float coul = 0.0;
	for(int i=0;i<100;i++) {  	
		coul+=0.01;
		lamb = distMarching(posRayon);
		posRayon += lamb * raydir ;
        		lambda += lamb ;
		break;	
	    }
	    				//calcul de la couleur
	gl_FragColor = vec4(coul);
	vec3 normale = pNormale(posRayon);
	vec3 ombre = vec3(dot(normale,raydir));
	gl_FragColor = vec4(normalize(abs(normale*2.0+ombre)),1.0);
	}
