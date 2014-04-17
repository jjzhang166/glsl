//
// some raymarched cones
// ztri/extend
//

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;


vec3 rotatey(vec3 r, float v)
{  return vec3(r.x*cos(v)+r.z*2.0*sin(v),r.y,r.z*cos(v)-r.x*sin(v));
}

vec3 rotatex(vec3 r, float v)
{ return vec3(r.y*cos(v)+r.z*sin(v),r.x,r.z*cos(v)-r.y*sin(v));
}


float terrain(in vec3 pos)
{

  
   float w1 = pow(sin(pos.x*0.00032)*sin(pos.z*0.00022)-0.7,3.0);
   float w2 = pow(sin(pos.x*0.00012)*sin(pos.z*0.00012)-0.1,3.0);
   float w3 = pow(sin(pos.x*0.00032)*sin(pos.z*0.00032)-0.4,3.0);
  
   float s = 0.0;   
   float s1 = max( smoothstep( -1.0 , 1.0, w1*100.0) * 9400.0  , s);
   float s2 = max( smoothstep( -1.0 , 1.0, w2*100.0) * 3800.0  , s); 
   float s3 = max( smoothstep( -1.0 , 1.0, w3*100.0) * 19800.0 , s); 

   s = max(s,s1);
   s = max(s,s2);
   s = max(s,s3);
     
  s -= pos.y;
  
  s*= 0.07;
  
  
  
  return s;
}


vec3 shootRay(vec3 cam,vec3 ray)
{

 float hit = 0.0; 
 vec3 test = cam + ray*30000.0;
 float dist = 1.0;

 for ( int iter = 1; iter < 100; iter += 1 ){

   hit = terrain(test);  
   test += ray*-hit;

 }
  
if( abs(hit) < 100.0){ 
  	return test;
} else {
    return vec3(0.0,0.0,9999999999.0); 
}

}





void main(void)
{

    vec2  p = (2.0 * (gl_FragCoord.xy / resolution.xy)) -1.0;
    vec2  m = mouse.xy - 0.5;
    float t = time * 1.21;
  
    vec3 campos = vec3(100.0 * sin(t) , 15000.0 * sin(t*0.4) + 20000.0,   (t*10000.0)  );
    vec3 raydir = normalize(vec3(0.0,0.0,1.0));

    raydir = rotatey( raydir, (m.x));
    raydir = rotatex( raydir,  (m.y) * 0.5);
  
    raydir = rotatey( raydir, (p.y*0.5));
    raydir = rotatex( raydir, (p.x*0.7));
  
    vec3 hit = shootRay(campos,raydir);
   
    float day = abs(sin(t*0.2));
    vec2 tex = vec2(sin(hit.x*0.002),sin(hit.z*0.002)); 
    float bumb = smoothstep(0.0,1.0,sin(tex.x*1.1+0.20)*sin(tex.y*4.231)*0.3);

  
    float axe = 50.0;
    float vx = terrain(hit+vec3(-axe, 0.0, 0.0))-terrain(hit+vec3( axe, 0.0, 0.0));
    float vy = terrain(hit+vec3( 0.0,-axe, 0.0))-terrain(hit+vec3( 0.0, axe, 0.0));
    float vz = terrain(hit+vec3( 0.0, 0.0,-axe))-terrain(hit+vec3( 0.0, 0.0, axe));

    vec3 n  = normalize(vec3(vx,vy,vz));
    vec3 ln1 = normalize(vec3(day-0.5,day*0.8,day*0.2+0.2));
    vec3 col = vec3(sin(hit.y*0.0001),0.2*abs(n.x),0.2*abs(n.z) ) + bumb;
    
    float angle = max(0.0,dot(n,ln1));
    col += angle * vec3(1.5,1.5,1.5);
    col += pow(angle,10.0) * vec3(10.5,10.5,10.5);
  
    float fog = max(0.0,min(1.0, (20000.0/distance(campos,hit))  ))  ; 
    
    vec3 fogc = mix(vec3(0.0,0.0,0.1),vec3(0.4,0.2,0.2),p.y)*day; 
  

    col = mix(col,fogc,1.0-(fog*fog*fog));  
  
    gl_FragColor = vec4(col, 1.0 );

}
