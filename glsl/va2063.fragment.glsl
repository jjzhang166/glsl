/* 

Playing around with sunlight and terrain.

ztri/extend

*/

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

const float dayspeed = 0.9;
const float maxdistance = 2000.0;
const float waterlevel = 150.0;

vec2 screenpos, mousepos;

vec3 sundir = vec3(0.0,1.0,0.0);
vec3 raydir = vec3(0.0,0.0,1.0);
vec3 campos = vec3(0.0,0.0,0.0);
float rayiterations = 0.0;


// Utils

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
  vec2 f = smoothstep(vec2(0.0,0.0),vec2(1.0,1.0),(fract(n)));
  return mix(mix(rand2d(b),rand2d(b+vec2(1.0,0.0)),f.x),mix(rand2d(b+vec2(0.0,1.0)),rand2d(b+vec2(1.0,1.0)),f.x),f.y);
}





// terrain 

float terrainbase(vec3 p){ 
   float t1 = (noise2d(vec2(p.x,p.z+sin(p.x*0.00001)*10000.0)*0.00082))*1000.0;
   return  t1 + p.y;
}

float terrain(vec3 p){  
  vec3 pp = p;
  float t1 = terrainbase(pp);
  float t2 = tan(noise2d(vec2(pp.x*0.0032,pp.z*0.0044)))*sin(pp.y*-0.0011)*100.0;
  float t3 = pow(noise2d(vec2(pp.x*0.0021,pp.z*0.0015 )),20.0)*50.0;
  float t4 = (max(0.0,tan(noise2d(pp.xz*0.07)-(pp.y*0.0001))))*-0.4;
  return (t1 + t2 + t3 + t4);
}




// enviroment  

vec3 env(vec3 dir,float dif){
 dir += 0.01;;		
 float n = noise2d(vec2(dir.z/dir.y,dir.x/dir.y)*0.31) * noise2d(vec2(dir.z/dir.y,dir.x/dir.y)*-0.6);

 float sunangle  = max(0.0,dot(dir,sundir));
 float sunamount = clamp(1.0 + sundir.y,0.0,1.0);
 float horizon   = clamp(0.5-sin(dir.y)*dif,0.0,1.0);
 float ground    = clamp((dir.y*10.0+0.5)*dif,0.0,1.0);

 vec3 color  =  vec3(0.6,0.7,0.8)  * sunamount * (horizon*0.2+0.8) * ground * 1.0; // sky color
      color  += vec3(1.0,0.8,0.4)  * sunangle  * horizon *  ground * 2.0; // horizon glow
      color  += vec3(1.0,0.8,0.4)  * pow(max(0.0,sunangle),50.0*dif) * ground * dif * 4.0; // sundisk  
      color  += vec3(0.6,0.6,0.6)  * sunamount * (1.0-horizon) * (1.0-ground) * 0.5; // ground color
      color  += vec3(0.5,0.5,0.5)  * sunamount * (n-0.5) * ground * dif; // clouds	
      color  += vec3(0.0,0.0,-0.0) * vec3(dot(dir,sundir));  // tint
	
 return color ;

}



// shade terrain

void shadeterrain(vec3 hit){
	
	float dist = dot(campos-hit,campos-hit)/(maxdistance*maxdistance);
	vec3  nh = floor(hit*10.0)*0.1;
	float noise = noise2d(nh.xz*0.11+sin(nh.y*0.05))*noise2d(nh.xz*0.31);    
	float noise2 = noise2d(nh.xz*0.021+sin(nh.y*0.01));    
	float noise3 = max(0.0,rand2d(floor(nh.xz*1.75))-dist*500.0);    

        // detail normal
	float vb = terrain(nh);
        float vx = vb-terrain(nh+vec3(1.0,0.0,0.0));
        float vy = vb-terrain(nh+vec3(0.0,1.0,0.0));
        float vz = vb-terrain(nh+vec3(0.0,0.0,1.0));
	vec3  n  = normalize(vec3(vx,vy,vz));
	
	// coarse normal    
	float vcb  = terrainbase(nh);
	float vcx  = vcb-terrainbase(nh+vec3(300.0,0.0,0.0));
	float vcy  = vcb-terrainbase(nh+vec3(0.0,300.0,0.0));
	float vcz  = vcb-terrainbase(nh+vec3(0.0,0.0,300.0));
        vec3 nn = normalize(vec3(vcx,vcy,vcz)); 
	    
	
	// fake shadow & ambient    
	float sh = smoothstep(0.0,0.2,max(0.0,dot(-nn,sundir)+0.3)*max(0.0,dot(-n,sundir)+0.3));
	float ao = smoothstep(1.0,0.0,(hit.y*0.0005+0.7) + smoothstep(0.0,5.0,abs(vx)+abs(vy)+abs(vz)) );
	
	
	// colors    
	vec3  rockc = vec3(0.2,0.19,0.18)+sin(noise2*noise+noise3)*-0.2;    
	vec3  snowc = vec3(0.8,0.8,0.9)-sin(noise*5.0+noise3)* 0.05 ;    
	float snowp = pow(clamp( abs(n.y*0.9)*abs(nn.y*1.4)+ hit.y*0.0001 + noise2*0.25 + noise*0.20 - (max(0.0,(hit.y+waterlevel+20.0)*0.05 ))  ,0.0,1.0),30.0);   
	vec3  color = mix(rockc,snowc,snowp);   
        
	
	// combine   
	vec3 col = (env(-n,0.1)) * ao * color.r ; // basecolor 
	     col = mix(col,env(reflect(raydir,-n),0.8), ao * sh * 0.1 * color.r); // env reflection 
	     col = col * (sh*0.5+0.5); // shadow
	     col = col *color;
    	     col = mix(col,env(raydir,1.0), dist); // fog
        
	
	gl_FragColor = vec4(col,1.0); 

}

void shadewater(vec3 hit){
	
	vec2 tex = vec2(raydir.x/raydir.y,raydir.z/raydir.y)*vec2(10.0,3.0); 
	float noise = noise2d(tex+vec2(sin(hit.z*0.001)*1.3,time));    
	vec3 color = env(normalize(vec3(raydir.x,-raydir.y+noise*0.2,raydir.z)),3.0)*0.1; 	  
	gl_FragColor = vec4(color,1.0); 

}

void shadeSky(){
	vec2 starmap = floor(raydir.xz*200.0)*0.1;
	float stars = max(0.0,rand2d(starmap)-0.99)*max(0.0,raydir.y)*50.0;
	gl_FragColor = vec4(max(env(raydir,1.0),vec3(stars,stars,stars)), 1.0 );	
}


void shadeFog(vec3 hit){
	float level = -800.0;
	vec2 tex = vec2(raydir.x/raydir.y,raydir.z/raydir.y); 
	float noise = noise2d(tex*vec2(0.4,0.1));    
	float fog = smoothstep(level,level+300.0,hit.y) * noise * 0.3;	
	gl_FragColor = mix(gl_FragColor,vec4(env(vec3(raydir.x,-raydir.y,raydir.z),0.04),1.0),fog);	
}


void shadePost(){
    float suntint = dot(sundir,raydir);
    float vignette = dot(screenpos,screenpos)*0.2;	
    gl_FragColor *= vec4(1.0,1.0-vignette,1.0-suntint*0.1-vignette,1.0)-((suntint+1.0)*0.2);
 
    vec3 gamma = vec3(2.1,2.2,2.2);	
    gl_FragColor =  vec4(pow(gl_FragColor.r,1.0/gamma.r),pow(gl_FragColor.g,1.0/gamma.g),pow(gl_FragColor.b,1.0/gamma.b),1.0); 	
}



vec3 raymarch(vec3 campos,vec3 raydir){
	vec3 test = campos;
   	float result = terrain(test);
   	float dist = 0.0;
   	float rayiterations = 0.0;
	for ( int it = 1; it < 200; it ++ ){
   		test += raydir*result;
   		result = terrain(test);
   		dist = dot(campos-test,campos-test)/(maxdistance*maxdistance);
   		if(abs(result)<dist*100.0+1.0){
      	  		return test;  
   		}
   		if(dist>1.0){
    	  		return vec3(0.0,0.0,0.0);
		}
		rayiterations++;
    	}	
	return test;	
}



void main(void){

    screenpos = (2.0 * (gl_FragCoord.xy / resolution.xy)) - 1.0;
    mousepos = mouse.xy - 0.5;
    raydir = normalize(vec3(screenpos.y,screenpos.x*(resolution.x/resolution.y),1.0));

	
    // Animation	
    float t = (time+199.0) * 0.50;
    if(mouse.x<0.01){ t = 115.0; };		
    float day = t * dayspeed;
    float scenetime  = t*0.1;
    float scenefade  = 1.0-pow(abs(fract(scenetime)*2.0-1.0),50.0);
    float sceneanim1 = sin(floor(scenetime)*35.0+fract(scenetime)*1.0);
    float sceneanim2 = sin(floor(scenetime)*36.0+fract(scenetime)*0.8);
    float sceneanim3 = sin(floor(scenetime)*36.0+fract(scenetime)*0.3);

	
    // Camera
    campos = vec3(0.0,0.0,-50.0);
    const float mousemove = 2.0; 	    
    raydir = rotatey( raydir,(mousepos.y*mousemove)+sceneanim3);
    raydir = rotatex( raydir,(mousepos.x*mousemove)+sceneanim1*0.5);
    campos = rotatey( campos,(mousepos.y*mousemove)+sceneanim3);
    campos = rotatex( campos,(mousepos.x*mousemove)+sceneanim1);	
    campos.z += t*200.0;
    campos.x = 500.0;
    campos.y = -max(waterlevel,terrain(vec3(campos.x,0.0,campos.z))) - 600.0  + ( 300.0 * sceneanim2) ;
  	
	
    // Raymarch
    vec3 hit = raymarch(campos,raydir);

    // Shade
    sundir = normalize(vec3(sin(day),cos(day),cos(day)*0.5));	
	
    if (hit.z == 0.0) {	    
  	 shadeSky();   
    } else if ( hit.y > -waterlevel -20.0){
	 shadewater(hit);
	 shadeFog(hit);	
    }  else {	
	 shadeterrain(hit);
	 shadeFog(hit);	
    }
    shadePost();
	
	
    gl_FragColor *= scenefade;
 		
}

		
		
