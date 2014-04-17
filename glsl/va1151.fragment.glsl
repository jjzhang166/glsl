// testing distance fields

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define FLOOR 0.0
#define BOX 1.0
#define TORUS 2.0
#define FIELD 3.0

vec3 board(vec3 v){
 float c = 0.0;
 float fx, fy;

 fx = fract(v.x);
 fy = fract(v.z);

 if(fx >= 0.5 && fy >= 0.5 || fx <= 0.5 && fy <= 0.5){
  c = 1.0;
 }  
 if(v.x < 0.5 && v.x > 0.0 && v.y < 0.5 && v.y>0.0){
  c = 0.0;
 }
 	
 return vec3(c,c,c);
}

float fog(vec3 eye, vec3 p){
 float f = 1.0/exp(length(p)*0.005);
 return f;
}

// floor at [0,-3,0], up: [0,1,0]
float floor_d(vec3 p){
 return p.y+3.0;
}

float rbox_d(vec3 p, vec3 b, float r )
{
  return length(max(abs(p)-b,0.0))-r;
}

float torus_d(vec3 p, vec2 t){  
  vec2 q = vec2(length(p.xz)-t.x,p.y);
  return length(q)-t.y;
}

float sphere_d(vec3 p, float r){
	return length(p)-r;
}

vec2 op_union(vec2 a, vec2 b){
 if(a.x < b.x)
  return a;
 return b;
}

vec2 op_subtract(vec2 a, vec2 b){
 if(-a.x > b.x){ 
  return vec2(-a.x, a.y);
 }
 return b;
}

vec2 op_intersect(vec2 a, vec2 b){
 if(a.x > b.x)
  return a;
 return b;
}

vec3 rep( vec3 p, vec3 c )
{
    	vec3 q = mod(p,c)-0.5*c;
   	return q;
}

vec2 march_step(vec3 p){
	vec2 t = vec2(1.5, 0.8);
	vec2 torus = vec2(torus_d(p, t), TORUS);
	
	float rbox_r = 0.1;
	vec3 rbox_dim = vec3(1.0, 1.0, 1.0);
	vec2 rbox = vec2(rbox_d(p, rbox_dim, rbox_r), BOX);
	
	vec2 x = op_intersect(rbox, torus);	
	
	vec2 fl = vec2(floor_d(p), FLOOR);
	
	//vec3 q = rep(p, vec3(5.0, 5.0, 5.0));
	//vec2 lol = vec2(rbox_d(q, rbox_dim, rbox_r), FIELD);	
	p = rep(p, vec3(2.0, 2.0, 2.0));
	vec2 lol = vec2(sphere_d(p, 0.3), FIELD);	
	
 	x = op_union(fl, x);
	x = op_union(x, lol);
	return x;
}


vec3 normal(float dist, vec3 p){
	vec2 e = vec2(0.01, 0.0);
	float dx = dist-march_step(p-e.xyy).x;
	float dy = dist-march_step(p-e.yxy).x;
	float dz = dist-march_step(p-e.yyx).x;
      	vec3 n = vec3(dx, dy, dz);
	n = normalize(n);

	return n;
}

void main( void ) {

	vec2 pos = -1.0 + 2.0*( gl_FragCoord.xy / resolution.xy );
	float aspect = resolution.x / resolution.y;
	
	vec3 up = vec3(0.0, 1.0, 0.0);
	vec3 lookat = vec3(0.0, 0.0, 0.0);
	//vec3 eye = vec3(2.0, 4.0, 5.0);
	vec3 eye = vec3(mod(time, 1000.0)+2.0, 4.0, 2.0);
	
	vec3 color = vec3(1.2, 1.2, 1.2);
	

	vec3 ray = normalize(lookat - eye);
	// view plane spanning vectors
	vec3 u = normalize(cross(up, ray));
	vec3 v = normalize(cross(ray, u));
	vec3 vp_center = eye+ray;

 	vec3 vp_point = vp_center + pos.x*u*aspect + pos.y*v;
  	vec3 vp_ray = vp_point - eye;


	float max_depth = 40.0;
	vec3 p = vec3(0,0,0);	
	vec2 o = vec2(1.0, -1);
	float f = 2.0;
	for(int i=0;i<128;i++){
	 if(abs(o.x)<0.1 || f > max_depth){
	  break;
	 }
	 f += o.x;
	 p = eye + f*vp_ray;
	 o = -march_step(p);
	}	
	
	if(f<max_depth){
	 if(o.y == FLOOR){
	  color = board(p);
	 }
        else{
	  if (o.y == BOX){
	   color = vec3(0.1, 0.5, 0.2);
	  }
		else if(o.y == FIELD){
			color = vec3(1.0,0.0,0.0);
			
		}
	  else{
           color = vec3(0.3, 0.1, 0.2);
          }	  
		
	   vec3 n = normal(o.x, p);
           float b=dot(n, normalize(eye-p));
	   color =vec3((b*color+pow(b,8.0))*(1.0-f*.01));//simple phong LightPosition=CameraPosition
	 }
	}

	//color = color * fog(eye, p);

	gl_FragColor = vec4( color, 1.0 );

}
