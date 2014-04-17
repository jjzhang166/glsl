#ifdef GL_ES
precision mediump float;
#endif


//
//  Raymarched jungle
//  ztri/extend
//


uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

vec2 screenpos, mousepos;
vec3 raydir = vec3(0.0,0.0,0.0);	
vec3 campos = vec3(0.0,0.0,0.0);
vec3 sundir = vec3(0.0,0.0,0.0);
float rayiterations = 0.0;


// 

vec3 rotatey(vec3 r, float v){  
  return vec3(r.x*cos(v)+r.z*sin(v),r.y,r.z*cos(v)-r.x*sin(v));
}

vec3 rotatex(vec3 r, float v){ 
  return vec3(r.y*cos(v)+r.z*sin(v),r.x,r.z*cos(v)-r.y*sin(v));
}

float rand2d(vec2 n){ 
  return fract(sin(dot(n,vec2(12.9898,4.1414))) * 43758.5453);
}

float noise2d(vec2 n){
  vec2 b = floor(n);
  vec2 f = smoothstep(vec2(0.0,0.0),vec2(1.0,1.0),fract(n));
  return mix(mix(rand2d(b),rand2d(b+vec2(1.0,0.0)),f.x),mix(rand2d(b+vec2(0.0,1.0)),rand2d(b+vec2(1.0,1.0)),f.x),f.y);
}

float cellular(vec2 P) {
	vec2  p  =  P-sin(P.yx)*0.2;
	float f1 =  abs(( sin(p.x + sin(p.y*0.414)*0.41 )) * ( cos(p.y + sin(p.x*0.732)*0.23 )));
	float f2 =  abs(( sin(p.y + sin(p.y*0.614)*0.34 )) * ( cos(p.x + sin(p.x*0.732)*0.36 )));
	return max(f1,f2);
}



// terrain 

float treelayer(vec3 p,float grid,float height,float size){
   
   vec3 pp = vec3(mod(p.x,grid)-grid*0.5,-p.y,mod(p.z,grid)-grid*0.5);   
   vec3 pd = p-pp;
	
   float n1 = rand2d(pd.xz);
   pp += vec3(sin(n1*14.0)*200.0,height+n1*1000.0-sin(pd.x*0.1)*200.0-sin(pd.z*0.1)*200.0,sin(n1*33.0)*400.0);
	
   float n2 = cellular(normalize(pp).xz*7.01);
   float leaves = n2*200.0;
	
   float tree = length(pp.xyz+noise2d(pp.xz*0.001)*400.0+sin(pp.y*0.005)*300.0) - size - leaves ; 
   float trunk = max(length(pp.xz+sin(p.y*0.002)*30.0)-5.0,p.y-100.0-height);

   float d = min(trunk,tree);	
   return d;
}



float terrain(vec3 p){ 

  float w1 =  pow(sin(p.x*0.00002+p.z*0.00003),5.0);
  float r1 =  noise2d(p.xz*0.002)*500.0 + p.y + 1000.0 - w1*3000.0;		
  float r2 =  treelayer(p*vec3(1.0,1.0,1.0),2530.0,1500.0*(sin(p.x*0.00035)+sin(p.z*0.00025)+1.0),500.0)+w1*100.0;	
  float r3 =  treelayer(p*vec3(0.9,1.2,0.9),3800.0,2000.0*(sin(p.x*0.00015)+sin(p.z*0.0001)+1.0), 1000.0)+w1*100.0;	
  float r4 =  treelayer(p*vec3(0.8,1.0,0.8),4800.0,1000.0*(sin(p.x*0.00015)+sin(p.z*0.0001)+1.0), 1500.0)+w1*100.0;	
  float r = min(r1,min(r2,min(r3,min(r4,p.y))));
  return r;	
}



// march

float raydistance = 0.0;
vec3 raymarch(vec3 campos,vec3 raydir){
	vec3 test = campos;
   	float result = 0.0;
   	float dist = 1000.0;
	float error = 0.0;
        rayiterations = 0.0;
	for ( int it = 0; it < 100; it ++ ){
   		
		error = clamp(pow(dist*0.00001,0.5),0.001,0.999);
		result = terrain(campos+raydir*dist)*error;
		
   		if(abs(result)< 0.1 + dist*0.003){
			raydistance = dist;
      	  		return campos+raydir*dist;  
   		}
		
   		if(dist>200000.0){
			raydistance = dist;
    	  		return vec3(0.0,0.0,0.0);
		}
		
		rayiterations++;
 		dist += result;  
  	
	}
	raydistance = dist;
   	return vec3(0.0,0.0,0.0);
}


// enviroment  

vec3 env(vec3 dir,float dif){
 
 dir += 0.01;;		
 float n = noise2d(vec2(dir.z/dir.y,dir.x/dir.y)*1.0) * noise2d(vec2(dir.z/dir.y,dir.x/dir.y)*-0.3);

 float sunangle  = max(0.0,dot(dir,sundir));
 float sunamount = clamp(0.9 + sundir.y,0.0,1.0);
 float horizon   = clamp(0.5-sin(dir.y)*dif,0.0,1.0);
 float ground    = clamp((dir.y*2.0+1.5)*dif,0.0,1.0);

 vec3 color  =  vec3(0.6,0.7,0.8)  * sunamount * (horizon*0.2+0.8) * ground * 1.5; // sky color
      color  += vec3(1.0,0.8,0.4)  * sunangle  * horizon *  ground * 3.0 * sunangle; // horizon glow
      color  += vec3(1.0,0.8,0.4)  * pow(max(0.0,sunangle),70.0) * ground * dif * 9.0; // sundisk  
      color  += vec3(0.6,0.6,0.6)  * sunamount * (1.0-horizon) * (1.0-ground) * 0.5; // ground color
      color  += vec3(0.5,0.5,0.5)  * sunamount * (n-0.3) * (ground*0.4) * dif; // clouds	
      color  += vec3(0.01,0.0,-0.01) * vec3(dot(dir,sundir));  // tint
	
return color ;

}



// shade

void shadeterrain(vec3 hit){
	
	
	float noise1 = pow(noise2d(hit.xz*0.01),2.0);    
	float ao  = pow(smoothstep(100.0,0.0,rayiterations) ,3.0);
	
	const float axe = 500.0; 
	float  nx = terrain(hit+vec3(-axe,0.0,0.0)) - terrain( hit+vec3(axe,0.0,0.0) );
	float  ny = terrain(hit+vec3(0.0,-axe,0.0)) - terrain( hit+vec3(0.0,axe,0.0) );
	float  nz = terrain(hit+vec3(0.0,0.0,-axe)) - terrain( hit+vec3(0.0,0.0,axe) );
	vec3 n = normalize(vec3(nx,ny,nz)); 

	vec3 ecn = env(-n,0.06);
	vec3 col1 = vec3(0.2,0.2+noise1*0.1,0.1)*ecn*(ao*ao);
	vec3 col2 = vec3(0.25,0.3+noise1*0.15,0.1)*ecn*ao;
	
	
	vec3 color = mix( col2,col1, smoothstep(1.0,0.0,hit.y*0.0005)+ noise1*0.4 );   	     
	color = mix(color,env(raydir,0.5),smoothstep(30000.0,100000.0,raydistance));
	
	gl_FragColor = vec4(color,1.0); 

}


void shadeSky(){
	vec2 starmap = floor(raydir.xz*200.0)*0.1;
	float stars = max(0.0,rand2d(starmap)-0.99)*max(0.0,raydir.y)*10.0;
	gl_FragColor = vec4(max(env(raydir,1.0),vec3(stars,stars,stars)), 1.0 );	
}



void shadePost(){
    float vignette = max(0.0,0.6 - pow(dot(screenpos,screenpos),0.3)*0.5);
    gl_FragColor *= vec4(vignette,vignette,vignette,1.0);	
    float suntint = dot(sundir,raydir);
    gl_FragColor *= vec4(1.0,1.0,1.0-suntint*0.1,1.0)-((suntint+1.0)*0.1);
    gl_FragColor *= 1.1 - rand2d(gl_FragCoord.xy+sin(time*0.01))*0.15;
    vec3 gamma = vec3(2.2,2.1,2.1);	
    gl_FragColor =  vec4(pow(gl_FragColor.r,1.0/gamma.r),pow(gl_FragColor.g,1.0/gamma.g),pow(gl_FragColor.b,1.0/gamma.b),1.0); 	
}







void main(void){

    screenpos = (2.0 * (gl_FragCoord.xy / resolution.xy)) - 1.0;
    mousepos = mouse.xy - 0.5;
    raydir = normalize(vec3(screenpos.y,screenpos.x*(resolution.x/resolution.y),1.3));

	
    // Animation
	
    float t = time * 0.20;
    //if(mouse.x<0.1){ t = 115.0; };		
    float day = t * 0.5;
    float scenetime  = t*0.1;
    float scenefade  = 1.0-pow(abs(fract(scenetime)*2.0-1.0),50.0);
    float sceneanim1 = sin(floor(scenetime)*35.0+fract(scenetime)*1.0);
    float sceneanim2 = sin(floor(scenetime)*36.0+fract(scenetime)*0.8);

	
    // Camera
	
    campos = vec3(0.0,0.0,0.0);
    const float mousemovex = 4.0; 	    
    const float mousemovey = 2.0; 	    

    raydir = rotatey( raydir,(mousepos.y*mousemovey)+sceneanim1);
    raydir = rotatex( raydir,(mousepos.x*mousemovex)+sceneanim1);
    campos = rotatey( campos,(mousepos.y*mousemovey)+sceneanim1);
    campos = rotatex( campos,(mousepos.x*mousemovex)+sceneanim1);	
    
    campos.y += 11000.0 + (sin(time*0.22)*2000.0);
    campos.z += 30000.0*sin(time*0.01)+1000.0;	
    campos.x += 30000.0*sin(time*0.03)+1000.0;	

	
    // Raymarch

    vec3 hit = raymarch(campos,raydir);

    sundir = vec3(sin(day),cos(day),0.0);	
	
    if (hit.z == 0.0 && raydistance > 200000.0) {	    
  	 shadeSky();   
    }  else {	
	 shadeterrain(hit);
    }
    
   shadePost();
 	
   gl_FragColor *= scenefade;	
}
