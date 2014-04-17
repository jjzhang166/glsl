#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec4 mouse;


vec3 rotatey(vec3 r, float v)
{  return vec3(r.x*cos(v)+r.z*sin(v),r.y,r.z*cos(v)-r.x*sin(v));
}

vec3 rotatex(vec3 r, float v)
{ return vec3(r.y*cos(v)+r.z*sin(v),r.x,r.z*cos(v)-r.y*sin(v));
}


float terrain(vec3 pos)
{
  float s = 0.0; //mod(pos.x*-0.5,50.0) + mod(pos.y*-0.5,50.0);
  s += sin(cos(pos.x*0.01)*0.2)*380.1;
  s += sin(sin(pos.z*0.01)*0.3)*101.3; 
  s += sin(cos(pos.y*0.01)*0.1)*200.3;
  s += (abs(pos.x)+abs(pos.z))*-0.01;
  s += pos.y*-0.6;
  return s;
}

vec3 shootRay(vec3 cam,vec3 ray)
{

 float surface = 0.0; 
 float hit = 0.0; 
 float error = 0.0;
 vec3 step = ray * 100.0;
 vec3 test = cam + ray*1000.0;

 for ( int iter = 1; iter < 30; iter += 1 ){
  hit = terrain(test);   

  if( abs(hit) < 1.0){ // did we hit the surface
  	return test;
  };
  
  error = clamp(100.0,-100.0,hit*-0.025); // move
  test += step * (error);
   
 }
  
if( abs(hit) < 10.0){ // close enough
  	return test;
} else {
    return vec3(0.,99999999.,0.0); 
}

}





void main(void)
{

    vec2 p = (2.0 * (gl_FragCoord.xy / resolution.xy)) -1.0 ;
    vec2 m = (2.0 * (mouse.xy / resolution.xy)) - 1.0;

    vec3 campos = vec3(1000.0 * cos(time*0.21) , 1200.0 , -1000.0);

    vec3 raydir = normalize(vec3(-0.3,0.0,1.0));
    
    raydir = rotatey( raydir, (p.y*0.3) );
    raydir = rotatex( raydir, (p.x*0.3) );


    vec3 hit = shootRay(campos,raydir);
   
    float axe = 0.01;
    float vx = terrain(hit+vec3(-axe, 0.0, 0.0))-terrain(hit+vec3( axe, 0.0, 0.0));
    float vy = terrain(hit+vec3( 0.0,-axe, 0.0))-terrain(hit+vec3( 0.0, axe, 0.0));
    float vz = terrain(hit+vec3( 0.0, 0.0,-axe))-terrain(hit+vec3( 0.0, 0.0, axe));

    vec3 n  = normalize(vec3(vx,vy,vz));
    vec3 sp = normalize(vec3(0.3,0.5,0.2));

    vec3 spot = dot(n,sp) * vec3(1.0,1.0,0.0);
    vec3 amb  = vec3(0.0,0.0,0.2);
  
    float fog  = 1.0; 

    gl_FragColor = vec4((spot+amb)*fog, 1.0 );

}

