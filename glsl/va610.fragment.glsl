//
// some raymarched desert
// ztri/extend
//

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;


vec3 rotatey(vec3 r, float v)
{  return vec3(r.x*cos(v)+r.z*sin(v),r.y,r.z*cos(v)-r.x*sin(v));
}

vec3 rotatex(vec3 r, float v)
{ return vec3(r.y*cos(v)+r.z*sin(v),r.x,r.z*cos(v)-r.y*sin(v));
}


float terrain(vec3 pos)
{
 
   vec3 p = pos * 0.00015;
   float s = 0.0;   
   s += abs( sin(p.x*0.3) + sin(p.z*0.3) ) * 2000.0;
   s -= abs( sin(p.x) + sin(p.z) ) * 800.0;
   s -= abs( sin(p.x*1.11) + sin(p.z*2.22) ) * 500.0;
   s -= abs( sin(p.x*1.81) + sin(p.z*1.11) ) * 400.0;

  s -= pos.y;
  
  return s;
}


vec3 shootRay(vec3 cam,vec3 ray)
{

 float hit = 0.0; 
 vec3 step = ray * 100.0;
 vec3 test = cam + ray*1000.0;

 for ( int iter = 1; iter < 50; iter += 1 ){

   hit = terrain(test);   

  if( abs(hit) < 10.0){ 
  	return test;
  };
  
  test += step * clamp(1000.0,-1000.0,hit*-0.010);
   
 }
  
if( abs(hit) < 2000.0){ 
  	return test;
} else {
    return vec3(0.0,0.0,9999999999.0); 
}

}





void main(void)
{

    vec2  p = (2.0 * (gl_FragCoord.xy / resolution.xy)) -1.0;
    vec2  m = mouse.xy - 0.5;
    float t = time * 0.21;
  
    vec3 campos = vec3(10000.0 * cos(t) , 2000.0 * sin(t) + 7000.0,  100.0 * sin(t*0.7) + (time*3000.0));
    vec3 raydir = normalize(vec3(0.0,0.0,1.0));

    raydir = rotatey( raydir, (m.x));
    raydir = rotatex( raydir,  (m.y) * 0.5 - 0.2);
  
    raydir = rotatey( raydir, (p.y*0.5));
    raydir = rotatex( raydir, (p.x*0.7));
  
    vec3 hit = shootRay(campos,raydir);
   
    float bump = abs(sin(hit.z*0.001)-abs(sin(hit.x*0.0001)-abs(sin(hit.y*0.001))));
    hit += bump*200.0;

    float day = abs(sin(t*0.2));
  
    float axe = 800.0;
    float vx = terrain(hit+vec3(-axe, 0.0, 0.0))-terrain(hit+vec3( axe, 0.0, 0.0));
    float vy = terrain(hit+vec3( 0.0,-axe, 0.0))-terrain(hit+vec3( 0.0, axe, 0.0));
    float vz = terrain(hit+vec3( 0.0, 0.0,-axe))-terrain(hit+vec3( 0.0, 0.0, axe));

    vec3 n  = normalize(vec3(vx,vy,vz));
  
  

    vec3 ln1 = normalize(vec3(day-0.5,day*0.8,day*0.2+0.2));
   
    vec3 lp2 = campos + vec3(sin(t*4.9)*4.0,abs(sin(t*3.8))+0.2,5.0)*10000.0;
    vec3 ln2 = normalize(lp2-hit);
    float ld2 = max(0.0, 9000.0 / distance(lp2,hit));
  
    vec3 col = vec3(0.1,0.1,0.14) + (bump*bump)* 0.02 ; 
     
    col += abs((cos(hit.x*124.8)+cos(hit.z*41224.8))*0.02); 
      
    col += max(0.0,dot(n,ln1)) * vec3(0.7,0.6,0.3);
  
    col += max(0.0,dot(n,ln2)) * vec3(4.5,3.4,2.6) * (ld2*ld2);
  
    float fog = max(0.0,min(1.0, (50000.0/distance(campos,hit) ) + (hit.y*0.0001) ))  ; 
    vec3 fogc = mix(vec3(0.3,0.4,0.45),vec3(0.80,0.9,1.0),p.y)*day;    

    col = mix(col,fogc,1.2-(fog*fog*fog));  
  
    gl_FragColor = vec4(col, 1.0 );

}
