// @mod*, colored by rotwang
// @mod+ some comments to scene function


#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float sphere(vec3 p)
{
	return length(p)-5.;
}

float cone(vec3 p)
{
	vec3 q = p*4.0;
	q.y *= 0.125;
	
	float len = length(q.xz);
	vec2 vv = vec2(len, q.y);
	float d = dot(vec2(0.25,0.25),vv);
	return d;
}



float displacement(vec3 p)
{
	return sin(p.x)*sin(p.y)*sin(p.z);
}

/**
Try to change the code to return only:
acone
asphere
both_shapes
*/
float scene( vec3 p )
{
	float acone = cone(-p);
	float asphere = sphere(p*1.5);
	
	float both_shapes = min(acone, asphere);
	float both_shapes_with_displacement = both_shapes + displacement(p*8.0)*0.05;

    	return both_shapes_with_displacement;
}

void main( void ) {

	vec2 p = -1. + 2.*gl_FragCoord.xy / resolution.xy;
	p.x *= resolution.x/resolution.y;
	
	//Camera animation
  vec3 vuv=vec3(0,1,0);//Change camere up vector here
  vec3 vrp=vec3(0,1,0); //Change camere view here
	float rs = time / 4.0;
	float st = sin(rs)*8.0;
	float ct = cos(rs)*8.0;
  vec3 prp=vec3(st,4,ct); //Change camera path position here

  //Camera setup
  vec3 vpn=normalize(vrp-prp);
  vec3 u=normalize(cross(vuv,vpn));
  vec3 v=cross(vpn,u);
  vec3 vcv=(prp+vpn);
  vec3 scrCoord=vcv+p.x*u+p.y*v;
  vec3 scp=normalize(scrCoord-prp);

  //Raymarching
  const vec3 e=vec3(0.1,0,0);
  const float maxd=24.0; //Max depth

  float s=0.1;
  vec3 c,p1,n;

  float f=0.1;
  for(int i=0;i<30;i++){
   // if (abs(s)<.01||f>maxd) break;//eliminating break so I can try out w/ core image.
    f+=s;
    p1=prp+scp*f;
    s=scene(p1);
  }
  	
	//replacing if/else with ternary to try out with apple's "core image"
	c=vec3(.2,0.6,0.8);
    	n=normalize(
      	vec3(s-scene(p1-e.xyy),
           s-scene(p1-e.yxy),
           s-scene(p1-e.yyx)));
    	float b=dot(n,normalize(prp-p1));
    	vec4 tex=vec4((b*c+pow(b,128.0))*(1.0-f*.01),1.0);
	tex += vec4(0.99,0.66,0.2,1.0)/f*2.0;
	vec4 background=vec4(0.0,0,0,1);
	
	vec4 Color=(f<maxd)?tex:background;
	
gl_FragColor=Color;

}