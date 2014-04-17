//
// some raymarched forest
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


float terrain(in vec3 pos)
{
 
   vec3 p =  pos / 10000.0;
   vec3 pp = pos - (floor(p)*10000.0);
     
   float w1 = max((sin(p.z*0.1)*sin(p.x*0.2)), clamp((sin(p.x*0.33)-cos(p.z*0.13)),-0.2,0.2) );
   float w2 = abs((sin(p.z*1.21)*cos(p.x*1.23))*1.9) - (sin(pos.y*0.005)*0.04);
     
   float s = 0.0;   

   s += max( smoothstep(w1-1.0,w1+1.0,w1*w1*w1)*23000.0 , s);
   s += max( smoothstep(w2-2.0,w2+2.0,w2*w2)*10000.0 * (sin(pp.z*0.001)+sin(pp.x*0.001)), s); 
   s -= pos.y;
   
  
  return s;
}


vec3 shootRay(vec3 cam,vec3 ray)
{

 float hit = 0.0; 
 vec3 step = ray * 100.0;
 vec3 test = cam + ray*10000.0;
 float dist = 0.0;

 for ( int iter = 1; iter < 40; iter += 1 ){

   hit = terrain(test);   

  if( abs(hit) < 100.0){ 
  	return test;
  };  
  test += step * clamp(1000.0,-1000.0,hit*-0.0031);
 }
  
if( abs(hit) < 50000.0){ 
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
  
    vec3 campos = vec3(10000.0 * cos(t) , 2000.0 * sin(t) + 60000.0,  100.0 * sin(t*0.6) + (time*100000.0));
    vec3 raydir = normalize(vec3(0.0,0.0,1.0));

    raydir = rotatey( raydir, (m.x));
    raydir = rotatex( raydir,  (m.y) * 0.5 - 0.2);
  
    raydir = rotatey( raydir, (p.y*0.5));
    raydir = rotatex( raydir, (p.x*0.7));
  
    vec3 hit = shootRay(campos,raydir);
   
    float day = abs(sin(t*0.2));
    //float bumb = pow(sin(hit.x*0.0001)*sin(hit.z*0.0001),4.0);

    float bumb = abs(sin(hit.x*0.004 + sin(hit.x*0.01) ) + sin(hit.z*0.005));
  
    float axe = 0.1;
    float vx = terrain(hit+vec3(-axe, 0.0, 0.0))-terrain(hit+vec3( axe, 0.0, 0.0));
    float vy = terrain(hit+vec3( 0.0,-axe, 0.0))-terrain(hit+vec3( 0.0, axe, 0.0));
    float vz = terrain(hit+vec3( 0.0, 0.0,-axe))-terrain(hit+vec3( 0.0, 0.0, axe));

    vec3 n  = normalize(vec3(vx,vy,vz));
    vec3 ln1 = normalize(vec3(day-0.5,day*0.8,day*0.2+0.2));
    vec3 col = vec3(0.0,0.3*abs(n.x),0.2*abs(n.z)) + (bumb*n.x*0.1);          
    col += max(0.0,dot(n,ln1)) * vec3(0.7,0.6,0.3);
  
    float fog = max(0.0,min(1.0, (100000.0/distance(campos,hit))  ))  ; 
    vec3 fogc = mix(vec3(0.3,0.4,0.45),vec3(0.80,0.9,1.0),p.y)*day;    
    col = mix(col,fogc,1.1-(fog*fog*fog));  
  
    gl_FragColor = vec4(col, 1.0 );

}
