#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec3 pacmanPos;
const vec3 NORMAL_BIAS = vec3(0.001, 0.0, 0.0);
const vec3 AMBIENT_COLOR = vec3(0.02,.0,.0);
const vec3 BACKGROUND_COLOR = vec3(.0);
float debug=5.0;

#define PI 4.141592
#define RADIANS 0.017453292
#define PLANE(p,z) p.y + z
#define MAX_DISTANCIA 99999.9
#define EPSILON 0.01
#define RAY_STEPS 2

float sdSphere( vec3 p, float s )
{
  return length(p)-s;
}

float opS( float d1, float d2 )
{
    return max(-d1,d2);
}

float udBox( vec3 p, vec3 b )
{
  return length(max(abs(p)-b,0.0));
}

float cunha( vec3 p, vec3 b,vec3 e )
{
  vec3 inter=mix(b,e,p.x);
  return length(max(abs(p)-inter,0.0));
}

float sdCone( vec3 p, vec2 c )
{
    // c must be normalized
    float q = length(p.xy);
    return dot(c,vec2(q,p.z));
}

float sdPlane( vec3 p, vec4 n )
{
  // n must be normalized
  return dot(p,n.xyz) + n.w;
}

float opI( float d1, float d2 )
{
    return max(d1,d2);
}

float opU( float d1, float d2 )
{
    return min(d1,d2);
}


float distObjeto(vec3 rayo,in int tipoObj,out float esfera1,out float esfera2,out float suelo,float fondo){

	esfera1,esfera2,suelo,fondo=MAX_DISTANCIA;
	
	if(tipoObj==0||tipoObj==1)	
		esfera1=sdSphere(rayo+pacmanPos,.3);
	if(tipoObj==0||tipoObj==2)	
		esfera2=cunha(rayo-vec3(0.9,0.0,0.0),vec3(.3,.3,.5),vec3(.3,.0,.5));
	if(tipoObj==0||tipoObj==3)		
		suelo=sdPlane(rayo-vec3(.0,-.5,.0),normalize(vec4(0.0,0.5,0.0,1.0)));//suelo=PLANE(rayo.y,-3.0);		
	if(tipoObj==0||tipoObj==4)		
		fondo=sdPlane(rayo-vec3(0.0,0.0,1.0),normalize(vec4(0.0,0.0,-0.1,1.0)));		

		
	return opU(esfera1,opU(esfera2,opU(suelo,fondo)));
}




vec3 colorObjeto(vec3 rayo){

	return vec3(1.0,1.0,0.0);
}


vec3 normal(in vec3 p, in int objType)
{
	float a;
	
	return normalize(vec3(
		distObjeto(p + NORMAL_BIAS.xyy,objType,a,a,a,a) - distObjeto(p - NORMAL_BIAS.xyy,objType,a,a,a,a),
		distObjeto(p + NORMAL_BIAS.yxy,objType,a,a,a,a) - distObjeto(p - NORMAL_BIAS.yxy,objType,a,a,a,a),
		distObjeto(p + NORMAL_BIAS.yyx,objType,a,a,a,a) - distObjeto(p - NORMAL_BIAS.yyx,objType,a,a,a,a)
	));
}

vec3 pacman(vec3 rayo,vec2 mouseuv){
	
	rayo+=pacmanPos;
	
	vec3 e = normalize(vec3(mouseuv.x, mouseuv.y, -1.0)) - rayo;
	float r = length(e);

	//if(acos(e.x/length(e))>5.0/(2.0*PI))
	if(rayo.x>0.0&&abs(rayo.y)<mix(0.0,mod(time,0.7),rayo.x))
		return vec3(.0);	
	else
		return vec3(1.0,1.0,.0);		
		
}

float shadow(in vec3 ro, in vec3 rd)
{
	float r = 1.00,a;
	float t = 0.01;
	
	for (int i = 0; i < RAY_STEPS; ++i)
	{
		float h = distObjeto(ro + t * rd, 0,a,a,a,a);
		if (h < EPSILON)
			return 0.0;
		r = min(r, 16.0 * h / t);
		t+= h;
	}
	
	return  r;
}


float softshadow( in vec3 ro, in vec3 rd, float k )
{
    float res = 1.0;float a;
    float t=0.0;
	for(int i=0;i<10;i++){	
        	float h =distObjeto(ro + rd*t,0,a,a,a,a);
       	 	if( h<0.001 )
        	    return 0.0;
	        res = min( res, k*h/t );
        	t += h;
	}
    
    return res;
}

vec3 luzAmbiente(vec3 rayo,vec3 foco,vec3 color){
	vec3 luzAmbiente=vec3(0.0,10.0,-2.0);
	float longitudLuzAmbiente=10.0;	
	
	if(length(rayo)!=0.0)
		return color*(longitudLuzAmbiente/length(rayo));
	else return vec3(0.0);
}

vec3 luz(in vec3 foco, in vec3 color, in vec3 colObj, in vec3 pos, in vec3 normal)
{
	if (dot(normal, foco) < 0.0)
		return colObj;	// Luz en sentido opuesto.
	
	foco = normalize(foco);
	float sha = softshadow( foco, pos, 4.0);//1.0;//shadow(pos, foco);
	colObj += max(0.0, dot(normal, foco)) * color * sha;
	
	return colObj;
}

vec3 opTx( vec3 p, float rotX, float rotY, float rotZ )
{
   /*mat4 m=mat4(
			1.0,cos(rotX),-sin(rotX),.0,
			.0,sin(rotX),cos(rotX),.0,  
		   	.0,.0,.0,.0,
			.0,.0,.0,1.0
	);	*/
   mat4 m=mat4(
			1.0,.0,.0,.0,
			cos(rotX),sin(rotX),.0,.0,  
		   	-sin(rotX),cos(rotX),.0,.0,
			.0,.0,.0,1.0
	);	
    vec4 q = m*vec4(p,.0);
	
    return vec3(q);
}


void main( void ) {

	float fov    = 1.0;//tan( 90.0 * RADIANS * 0.5);
	
	vec2 uv = ((gl_FragCoord.xy / resolution.xy) * 2.0 - 1.0);	
	vec2 mouseuv=mouse * 2.0 - 1.0;
	
	float aspectRatio=resolution.x/resolution.y;
	
	vec3 origen=vec3(2.0,1.0,-2.0);
	vec3 destino=normalize(vec3(uv.x*aspectRatio * fov,uv.y,1.0));	
	//origen=origen*mouseuv.x;
	//origen=opTx(origen-destino,mouseuv.x*PI,mouseuv.y,0.0);
	//origen=origen-destino;
	
	vec3 focoLuz=vec3(.0,mod(time,4.0),0.0);
	vec3 colorLuz=vec3(1.0);	
	
	vec3 rayo=origen;
	
	pacmanPos=-vec3(-1.0,0.0,0.0)-mod(vec3(.2,.0,.0)*time*2.0,5.0);	
	
	//float shadow_t=0.0;
	//float sombra=softshadow(focoLuz,destino,16.0);
	
	float dist,esfera1,esfera2,suelo,fondo;
	
	for(int i=0;i<RAY_STEPS;i++){
		//rayo=opTx(rayo,mouseuv.x,mouseuv.y,0.0);
		dist=distObjeto(rayo,0,esfera1,esfera2,suelo,fondo);
		rayo+=dist*destino;
	}
			 
	//dist=opU(dist,sombra);		 
	
	vec3 color=BACKGROUND_COLOR;
	
	int objetoActual=0;
	
	if(dist==esfera1){
		objetoActual=1;
		color=pacman(rayo,mouseuv);
	}
	else if(dist==esfera2){
		objetoActual=2;
		color=vec3(1.0,0.0,1.0);	
	}
	else if(dist==suelo){
		objetoActual=3;	
		color=vec3(0.0,0.0,1.0);		
	}
	else if(dist==fondo){
		objetoActual=4;		
		color=vec3(0.0,0.0,1.0);		
	}
	//else if(dist==sombra)
	//	color=vec3(0.0,0.0,0.0);
	else
		color=vec3(0.0);
		
	
	vec3 colorFinal=/*luzAmbiente(rayo,focoLuz,AMBIENT_COLOR)+*/luz(vec3(-3.0,-10.0,.0), colorLuz, color,vec3(.0),normal(rayo,objetoActual));
	
	if(length(rayo)!=0.0&&colorFinal!=vec3(.0))
		gl_FragColor = vec4(colorFinal,1.0);
	//else
	//	gl_FragColor = vec4(rayo,1.0);
	
}