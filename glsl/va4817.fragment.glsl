// @mod*, colored by rotwang

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
//passing time through so it can work w core image.-gt
float displacement(vec3 p, float time)
{
	return sin(1.0*p.x+time)*sin(3.0*p.y+10.0*time)*0.25*sin(7.0*p.z+time);
}

float opDisplace( vec3 p, float time )
{
	float d1 = sphere(p);
    	float d2 = displacement(p, time);
    	return d1+d2;
}

void main( void ) {

	vec2 p = -1. + 2.*gl_FragCoord.xy / resolution.xy;
	p.x *= resolution.x/resolution.y;
	
	//Camera animation
  vec3 vuv=vec3(0,1,0);//Change camere up vector here
  vec3 vrp=vec3(0,1,0); //Change camere view here
  vec3 prp=vec3(sin(time)*8.0,4,cos(time)*8.0); //Change camera path position here

  //Camera setup
  vec3 vpn=normalize(vrp-prp);
  vec3 u=normalize(cross(vuv,vpn));
  vec3 v=cross(vpn,u);
  vec3 vcv=(prp+vpn);
  vec3 scrCoord=vcv+p.x*u+p.y*v;
  vec3 scp=normalize(scrCoord-prp);

  //Raymarching
  const vec3 e=vec3(0.1,0,0);
  const float maxd=16.0; //Max depth

  float s=0.1;
  vec3 c,p1,n;

  float f=1.0;
  for(int i=0;i<30;i++){
   // if (abs(s)<.01||f>maxd) break;//eliminating break so I can try out w/ core image.
    f+=s;
    p1=prp+scp*f;
    s=opDisplace(p1, time);
  }
  	
	//replacing if/else with ternary to try out with apple's "core image"
	//c=vec3(.2,0.6,0.8);
	c = vec3(0.0);
    	n=normalize(
      	vec3(s-opDisplace(p1-e.xyy, time),
           s-opDisplace(p1-e.yxy, time),
           s-opDisplace(p1-e.yyx, time)));
    	float b=dot(n,normalize(prp-p1));
    	vec4 tex=vec4((b*c + pow(b,40.0))*(1.0-f*.01),1.0);
	//tex += vec4(0.99,0.66,0.2,1.0)/f*2.0;
	vec4 background=vec4(0.0,0.0,0.0,1.0);
	
	gl_FragColor=(f<maxd)?tex:background;
	


}