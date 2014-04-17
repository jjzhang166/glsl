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

float displacement(vec3 p)
{
	return sin(p.x) + sin(p.y) + sin(p.z);
}

float opDisplace( vec3 p )
{
	float d1 = sphere(p);
	vec3 s = p+time;
	// mercury ftw
    	float d2 = displacement(s);
	d2 += displacement(vec3(d2 * 3.0)) * 0.5;
	d2 += displacement(vec3(d2 * 5.0)) * 0.1;

	
    	return max(d1,-(d2/6.0));
}

void main( void ) {

	vec2 p = -1. + 2.*gl_FragCoord.xy / resolution.xy;
	p.x *= resolution.x/resolution.y;
	
	//Camera animation
  vec3 vuv=vec3(0,1,0);//Change camere up vector here
  vec3 vrp=vec3(0,1,0); //Change camere view here
  vec3 prp=vec3(sin(time*0.2)*8.0,4,cos(time*0.2)*8.0); //Change camera path position here

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
  for(int i=0;i<16;i++){
   // if (abs(s)<.01||f>maxd) break;//eliminating break so I can try out w/ core image.-gtoledo
    f+=s;
    p1=prp+scp*f;
    s=opDisplace(p1);
  }
  	
	//replacing if/else with ternary to try out with apple's "core image"-gtoledo
	c=vec3(.3,0.5,0.8);
    	n=normalize(
      	vec3(s-opDisplace(p1-e.xyy),
           s-opDisplace(p1-e.yxy),
           s-opDisplace(p1-e.yyx)));
    	float b=dot(n,normalize(prp-p1));
    	vec4 tex=vec4((b*c+pow(b,8.0))*(1.0-f*.01),1.0);
	vec4 background=vec4(0,0,0,1);
	
	vec4 Color=(f<maxd)?tex:background;
	
  	/*if (f<maxd){
      	c=vec3(.3,0.5,0.8);
    	n=normalize(
      	vec3(s-opDisplace(p1-e.xyy),
           s-opDisplace(p1-e.yxy),
           s-opDisplace(p1-e.yyx)));
    	float b=dot(n,normalize(prp-p1));
   	gl_FragColor=vec4((b*c+pow(b,8.0))*(1.0-f*.01),1.0);
  	}
  	else gl_FragColor=vec4(0,0,0,1);
	*/
//to use with core image, just replace with "return Color" - gt
gl_FragColor=Color;

}