#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const vec3 NORMAL_BIAS = vec3(0.001, 0.0, 0.0);
const vec3 AMBIENT_COLOR = vec3(0.01);
const vec3 BACKGROUND_COLOR = vec3(.0);
float debug=5.0;
vec3 pacmanPos;
vec3 fantasma1Pos,fantasma2Pos,fantasma3Pos;

#define PI 3.141592
#define RADIANS 0.017453292
#define PLANE(p,z) p.y + z
#define MAX_DISTANCIA 9999999.9
#define EPSILON 0.0001
#define RAY_STEPS 64
#define RAYTRACING 0
#define RAYMARCHING 1
#define MODE RAYMARCHING

float iSphere( in vec3 ro, in vec3 rd, in vec4 sph ) {
	vec3 oc = ro - sph.xyz; // looks like we are going place sphere from an offset from ray origin, which is = camera
	//float r = 1.0;
	float b = 2.0*dot( oc, rd );
	float c = dot(oc, oc) - sph.w * sph.w; // w should be size
	float h = b*b - 4.0 *c;
	if (h<0.0 ) return MAX_DISTANCIA;
	float t = (-b - sqrt(h)) / 2.0;
	return t;
}

float iPlaneY( in vec3 ro, in vec3 rd, in vec3 pos ) { return (-ro.y / rd.y)*((pos.y!=0.0)?pos.y:1.0); }
float iPlaneZ( in vec3 ro, in vec3 rd, in vec3 pos ) {
	
	float des=1.0;
	
	float wallSize=0.2;
	float wallZ=0.9;
	
	float base=(-ro.z / rd.z)*rd.y;
	
	if(base>0.6&&base<0.9)des=mix(1.0,0.85,base-0.6);
	if(base>=0.9&&base<1.2)des=mix(0.85,1.0,base-0.9);
	
	return (-ro.z / rd.z)*des*((pos.z!=0.0)?pos.z:1.0); 
}

float sdSphere( vec3 p, float s )
{
  return length(p)-s;
}

float iBox(in vec3 ro,in vec3 rd,in vec3 boxPos,in vec3 boxSize,out vec3 normal)
{
  vec3 rdinv=1.0/rd;	
	
  float tx1 = (boxPos.x - ro.x)*rdinv.x;
  float tx2 = (boxPos.x+boxSize.x - rd.x)*rdinv.x;
 
  float tmin = min(tx1, tx2);
  float tmax = max(tx1, tx2);
 
  float ty1 = (boxPos.y - ro.y)*rdinv.y;
  float ty2 = (boxPos.y+boxSize.y - ro.y)*rdinv.y;
 
  tmin = max(tmin, min(ty1, ty2));
  tmax = min(tmax, max(ty1, ty2));
	
  float tz1 = (boxPos.z - ro.z)*rdinv.z;
  float tz2 = (boxPos.z+boxSize.z - ro.z)*rdinv.z;
 
  tmin = max(tmin, min(tz1, tz2));
  tmax = min(tmax, max(tz1, tz2));
	
  if(tmin==tx1)normal=vec3(-1.0,.0,.0);
  else if(tmin==ty1)normal=vec3(.0,-1.0,.0);	
  else if(tmin==tz1)normal=vec3(.0,.0,-1.0);		  
 
  return (tmax >= tmin)?tmin:-1.0;
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

float opDisplace( vec3 p ,float dist)
{
			
    return dist+sin(p.x*4.0*PI)/60.0;
}

float opI( float d1, float d2 )
{
    return max(d1,d2);
}

float opU( float d1, float d2 )
{
    return min(d1,d2);
}

float sdCylinder( vec3 p, vec3 c )
{
  return length(p.xz-c.xy)-c.z;
}

float map(in vec3 rayo,in int tipoObj,out float esfera1,out float esfera2,out float suelo,out float fondo){

	float dist;	
		
	if(tipoObj==0||tipoObj==1)	
		esfera1=sdSphere(rayo+pacmanPos,.4);
	if(tipoObj==0||tipoObj==2)	
		esfera2=opI(opU(sdSphere(rayo+fantasma1Pos+vec3(.0,.3,.0),.4),
			    opU(sdSphere(rayo+fantasma1Pos+vec3(.0,.15,.0),.4),sdSphere(rayo+fantasma1Pos,.4)))
			    ,udBox(rayo+fantasma1Pos+vec3(.0,-.1,.0),vec3(.5,.5,.5)));//);
	if(tipoObj==0||tipoObj==3)		
		suelo=sdPlane(rayo-vec3(.0,.0,.0),normalize(vec4(0.0,.5,0.0,1.0)));//suelo=PLANE(rayo.y,-3.0);		
	if(tipoObj==0||tipoObj==4)		
		fondo=sdPlane(rayo-vec3(0.0,0.0,1.0),normalize(vec4(0.0,0.0,-.5,1.0)));	

	dist=opU(esfera1,opU(esfera2,opU(suelo,fondo)));	
	
	return dist;
}


float distObjeto(in vec3 origen,in vec3 destino,in int tipoObj,out float esfera1,out float esfera2,out float suelo,out float fondo,out vec3 rayoF){

	esfera1,esfera2,suelo,fondo=MAX_DISTANCIA;
	
	vec3 normal,rayo=origen;
	float dist=MAX_DISTANCIA;
	
if(MODE==RAYTRACING){
	if(tipoObj==0||tipoObj==1){
		esfera1=iSphere(origen,destino,vec4(pacmanPos,.4));
		if(esfera1>=0.0)
			dist=min(dist,esfera1);	
		if(tipoObj!=0)return esfera1;
	}
	if(tipoObj==0||tipoObj==2){
		esfera2=iBox(origen,destino,fantasma1Pos+vec3(.0,-.0,.0),vec3(1.0),normal);
		//	opS(opU(iSphere(origen,destino,vec4(fantasma1Pos,.4)),
		//	    opU(iSphere(origen,destino,vec4(fantasma1Pos+vec3(.0,.15,.0),.4)),
		//	    	iSphere(origen,destino,vec4(fantasma1Pos+vec3(.0,.30,.0),.4)))),
		//		iBox(origen,destino,fantasma1Pos+vec3(.0,-.20,.0),vec3(.4),normal)
		//	   );//iSphere(origen,destino,vec4(fantasma1Pos+vec3(.0,.3,.0),.4));	
		if(esfera2>=0.0)
			dist=min(dist,esfera2);
		if(tipoObj!=0)return esfera2;
	}
	if(tipoObj==0||tipoObj==3){
		suelo=iPlaneY( origen, destino,vec3(.0,.0,.0) );
		if(suelo>=0.0)
			dist=min(dist,suelo);
		if(tipoObj!=0)return suelo;
	}
	if(tipoObj==0||tipoObj==4){
		fondo=iPlaneZ( origen, destino,vec3(.0,.0,5.0) );
		if(fondo>=0.0)
			dist=min(dist,fondo);
		//if(tipoObj!=0)return fondo;		
	}
	return dist;		
}else{
	
	for(int i=0;i<RAY_STEPS;i++){
		dist=map(rayo,tipoObj,esfera1,esfera2,suelo,fondo);
		rayo+=dist*destino;
	}	
	rayoF=rayo;
	return dist;
}
}


float ao(in vec3 ro, in vec3 rd, in int objType,in vec3 pos, in vec3 nor)
{
	float ao,a;vec3 b;
	float totao = 0.0;
	float sca   = 1.0;
	
	for (int aoi = 0; aoi < 5; aoi++)
	{
		float hr    = 0.01 + 0.02 * float(aoi * aoi);
		vec3  aopos = nor * hr + pos;
		float dd    = distObjeto(ro, rd,objType,a,a,a,a,b);
		ao     = -(dd - hr);
		totao += ao * sca;
		sca   *= 0.75;
	}
	
	return 1.0 - clamp(totao, 0.0, 1.0);
}

vec3 colorObjeto(vec3 rayo){

	return vec3(1.0,1.0,0.0);
}

vec3 nSphere( in vec3 pos, in vec4 sph ) { return ( pos - sph.xyz )/ sph.w; } 

vec3 normal(in vec3 p, in int objType,in vec4 objPos)
{
	float a;
	
if(MODE==RAYTRACING){
	if(objType==1){
		return ( p - objPos.xyz )/ objPos.w; 
	}else
	if(objType==3){
		return vec3 (0.0, 1.0, 0.0);
	}else
	if(objType==4){
		return vec3 (0.0, 0.0, -1.0);
	}		
}
else{	
	return normalize(vec3(
		map(p + NORMAL_BIAS.xyy,objType,a,a,a,a) - map(p - NORMAL_BIAS.xyy,objType,a,a,a,a),
		map(p + NORMAL_BIAS.yxy,objType,a,a,a,a) - map(p - NORMAL_BIAS.yxy,objType,a,a,a,a),
		-1.0*map(p + NORMAL_BIAS.yyx,objType,a,a,a,a) - map(p - NORMAL_BIAS.yyx,objType,a,a,a,a)
	));
}
}

vec3 pacman(vec3 pos,vec2 mouseuv){	

	if(MODE==RAYTRACING)
		pos-=pacmanPos;
	else
		pos+=pacmanPos;
		
	if(length(vec2(pos.x,pos.y)-vec2(.0,.25))<0.06)
		if(length(vec2(pos.x,pos.y)-vec2(.0,.25))<0.035)
			return vec3(1.0);
		else
			return vec3(.0);
	else if(pos.x>0.0&&abs(pos.y)<mix(0.0,mod(time,0.7),pos.x))
		return vec3(.0);	
	else
		return vec3(1.0,1.0,.0);		
		
}

vec3 fantasma(vec3 pos){	

	if(length(vec2(pos.x,pos.y)-vec2(-.15,.1))<0.1)
		if(length(vec2(pos.x,pos.y)-vec2(-.15,.05))<0.08)
			return vec3(1.0);
		else
			return vec3(.0);
	else if(length(vec2(pos.x,pos.y)-vec2(.15,.1))<0.1)
		if(length(vec2(pos.x,pos.y)-vec2(.15,.05))<0.08)
			return vec3(1.0);
		else
			return vec3(.0);
	else	
		return vec3(1.0,.0,1.0);		
		
}

vec3 colorSuelo(vec3 pos){
		if(mod(pos.x,2.0)<1.0)
			if(mod(pos.z,2.0)<1.0)			
				return vec3(1.0);		
			else
				return vec3(0.0);		
		else
			if(mod(pos.z,2.0)>=1.0)			
				return vec3(1.0);		
			else
				return vec3(0.0);
}

vec3 colorFondo(vec3 pos){
		if(mod(pos.x,2.0)<1.0)
			if(mod(pos.y,2.0)<1.0)			
				return vec3(1.0);		
			else
				return vec3(0.0);		
		else
			if(mod(pos.y,2.0)>=1.0)			
				return vec3(1.0);		
			else
				return vec3(0.0);
}

float shadow(in vec3 ro, in vec3 rd)
{
	float r = 1.00,a;
	float t = 0.01;
	
	for (int i = 0; i < RAY_STEPS; ++i)
	{
		float h = map(ro + t * rd, 0,a,a,a,a);
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
        	float h =map(ro + rd*t,0,a,a,a,a);
       	 	if( h<0.001 )
        	    return 0.0;
	        res = min( res, k*h/t );
        	t += h;
	}
    
    return res;
}

vec3 luzAmbiente(vec3 col,vec3 rayo,vec3 foco,vec3 lcol){
	vec3 luzAmbiente=vec3(0.0,10.0,-2.0);
	float longitudLuzAmbiente=10.0;	
	
	if(length(rayo)!=0.0)
		return col+lcol*(longitudLuzAmbiente/length(rayo));
	else return col;
		
}

vec3 prelight(in vec3 ro, in vec3 rd, in float dist,in int objType, in vec4 objPos,in vec3 col, out vec3 pos, out vec3 nor)
{
	pos = ro + dist * rd;
	nor = normal(pos, objType,objPos);

	float  amb = 0.5 + 0.5 * nor.y;
	return col + amb * AMBIENT_COLOR;
}

vec3 luzReflejo(in vec3 destino, in vec3 pos, in vec3 nor, in vec3 lig, in vec3 lcol, in float shi, in vec3 col)
{
	if (dot(nor, lig) < 0.0)
		return col;	// Light source on the wrong side.
	
	col += lcol * pow(max(0.0, dot(nor, normalize(destino - pos + lig))), shi);
	
	return col;
}

vec3 postlight(in vec3 ro, in vec3 rd, in int objtype,in vec3 pos, in vec3 nor, in vec3 col, in vec2 q)
{
	vec3 dif = vec3(0.2, 0.2, 0.7);
	col = col * dif * ao(ro, rd, objtype,pos, nor);
	col = 0.3 * col + 0.5 * sqrt(col);
	col *= 0.25 + 0.75 * pow(16.0 * q.x * q.y * (1.0 - q.x) * (1.0 - q.y), 0.15);
	
	return col;
}



vec3 luz(in vec3 foco, in vec3 color, in vec3 colObj, in vec3 pos, in vec3 normal)
{
	if (dot(normal, foco) < 0.0)
		return colObj;	// Luz en sentido opuesto.
	
	foco = normalize(foco);
	float sha = 1.0;//softshadow( foco, pos, 8.0);//1.0;//shadow(pos, foco);
	colObj += max(0.0, dot(normal, foco)) * color *sha;
	
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


vec3 raydir(in vec3 ro, in float rot, in float z, in vec2 q)
{
	vec2 p = -1.0 + 2.0 * q;
	p.x *= resolution.x / resolution.y;
	vec3 ww = normalize(-ro);
	vec3 uu = normalize(cross(vec3(rot, 5.0, 0.0), ww));
	vec3 vv = normalize(cross(ww, uu));
	
	return normalize(p.x * uu + p.y * vv + z * ww);
}

void main( void ) {

	float fov    = tan( 75.0 * RADIANS * 0.5);
	vec2 q = gl_FragCoord.xy / (resolution.xy + 1.0);
	vec2 uv = q;	
	vec2 mouseuv=mouse * 2.0 - 1.0;
	
	float aspectRatio=1.0;//resolution.x/resolution.y;
	
	//vec3 origen=vec3(2.0,1.0,-2.0);
	//vec3 destino=normalize(vec3(uv.x*aspectRatio * fov,uv.y,1.0));	
	vec3 origen = vec3( 1.0, 1.0, -6.0 ); //ray origin
	vec3 destino = normalize( vec3( -1.0 + 2.0*uv* vec2(aspectRatio, 1.0), 1.0 ) ); // ray destination
	//destino.x*=aspectRatio;
	//destino=raydir(origen, 0.0, 1.5, q);
	//origen.y = 1.0+2.0*cos(time * 1.5);
	//origen.z = 4.0 + sin(time);	
	
	vec3 focoLuz=vec3(0.1,10.0,.1);
	 //focoLuz=normalize( vec3(0.5,0.6,-2.0));//+sin(time*3.0) );
	vec3 colorLuz=vec3(1.0);	
	vec3 rayoF;	

	pacmanPos=vec3(-3.0,1.0,3.0)+mod(vec3(.1,.0,.0)*time*20.0,10.0);	
	fantasma1Pos=vec3(8.0,1.5,0.0)-mod(vec3(.1,.0,.0)*time*10.0,10.0);	
	
	
	//float shadow_t=0.0;
	//float sombra=softshadow(focoLuz,destino,16.0);
	
	float dist,esfera1,esfera2,suelo,fondo;
	dist=distObjeto(origen,destino,0,esfera1,esfera2,suelo,fondo,rayoF);
	//dist=opU(dist,sombra);		 
	
	vec3 color=BACKGROUND_COLOR;
	
	vec3 pos=origen+destino*dist;
	//vec3 pos,nor;	
	
	int objetoActual=0;
	
	if(MODE==RAYTRACING)
		rayoF=pos;
	
	if(MODE==RAYTRACING&&dist<=0.0||dist>=MAX_DISTANCIA){
		objetoActual=0;
		color=BACKGROUND_COLOR;	
	}
	else if(dist==esfera1){
		objetoActual=1;
		color=pacman(rayoF,mouseuv);
	}
	else if(dist==esfera2){
		objetoActual=2;
		color=fantasma(rayoF+fantasma1Pos);	
	}
	else if(dist==suelo){
		objetoActual=3;	
		color=colorSuelo(rayoF);
	}
	else if(dist==fondo){
		objetoActual=4;	
		color=colorFondo(rayoF);			
	}
	//else if(dist==sombra)
	//	color=vec3(0.0,0.0,0.0);
	else
		color=vec3(0.0);
	
	//rayo=normalize(rayo);

	vec3 nor;//=normal(pos,objetoActual);
	if(MODE==RAYMARCHING){
		nor=normal(pos,objetoActual,vec4(pos,0.4));
	}
	
	vec3 colorFinal=color;
	
	// sphere		
	if(objetoActual==1||objetoActual==2){
		if(MODE==RAYTRACING)
		if(objetoActual==1)
			nor = nSphere( pos,vec4(pacmanPos,.5) );
		else
			nor = nSphere( pos,vec4(fantasma1Pos,.5) );			
		nor = normalize(vec3(.5,.5,.0));	
		float dif = clamp( dot( nor, focoLuz ), 0.0, 1.0); // diffuse light
		float ao = 0.5 + 0.5 * nor.y;
		colorFinal = ao*colorFinal;//vec3( 0.8, 0.8, 0.6) * dif * ao + colorFinal * ao;
	} else if ( objetoActual==3||objetoActual==4) {
		// plane
		if(MODE==RAYTRACING)		
		if(objetoActual==3){
			nor = vec3(.0,1.0,.0);
		}
		else{
			nor = vec3(.0,.0,-1.0);	
		}
		float dif = clamp( dot(nor, focoLuz), 0.0, 1.0 );
		float amb = smoothstep( 0.0, .5 * 2.0, min(length(pos.xz - pacmanPos.xz),length(pos.xz - fantasma1Pos.xz))*length(focoLuz - pos) ); // shadows under the sphere
		if(objetoActual==4)amb=0.5;
		colorFinal = colorFinal+0.10*vec3 (amb * 0.9);
	}
	colorFinal=sqrt(colorFinal);		
	
	//colorFinal=prelight(origen,destino,dist,objetoActual,color,pos,nor);
	//colorFinal=luzAmbiente(color,destino,focoLuz,AMBIENT_COLOR);
	//colorFinal=luz(focoLuz, colorLuz, colorFinal,pos,nor);
	//colorFinal=luzReflejo(destino,pos,nor,focoLuz,colorLuz,10.0,colorFinal);
	//colorFinal=postlight(origen, destino,objetoActual, pos, nor, colorFinal,q);

	//if(length(pos)!=0.0&&colorFinal!=vec3(.0))
		gl_FragColor = vec4(colorFinal,1.0);
	//else
	//	gl_FragColor = vec4(rayo,1.0);
	
}