// Fixed shadows and ambient occlusion bugs, and sped some shit up.
// Still needs some work
// Voltage / Defame (I just fixed some bugs, someone else did they main work on this)

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
//Simple raymarching sandbox with camera

//Raymarching Distance Fields
//About http://www.iquilezles.org/www/articles/raymarchingdf/raymarchingdf.htm
//Also known as Sphere Tracing
//Original seen here: http://twitter.com/#!/paulofalcao/statuses/134807547860353024

//Util Start
vec2 ObjUnion(in vec2 obj_floor,in vec2 obj_roundBox){
  if (obj_floor.x<obj_roundBox.x)
  	return obj_floor;
  else
  	return obj_roundBox;
}
//Util End

//Scene Start

//Torus
float torus(in vec3 p, in vec2 t){
	vec2 q = vec2(length(vec2(p.x,p.z))-t.x, p.y);
	return length(q) - t.y;
}

//Sphere
float sphere(in vec3 p, float radius){
	p.y -= 1.0;
	float length = sqrt(p.x*p.x + p.y*p.y + p.z*p.z);
	return length-radius;
}

//Floor
vec2 obj_floor(in vec3 p){
  return vec2(p.y+6.0,0.0);
}

//Floor Color (checkerboard)
vec3 obj_floor_c(in vec3 p){
	float a,x,z,t=0.0;
	for (int xii=-8;xii<7;xii++) {
		for (int zii=-8;zii<7;zii++) {
			x=fract((p.x+float(xii)*0.006)*0.25);
			z=fract((p.z+float(zii)*0.006)*0.25);
			if (x>.5)
				if (z>.5) {
					a=0.0;
				} else {
					a=1.0;
				} 
			else
				if (z>.5) {
					a=1.0;
				} else {
					a=0.0;
				}	
		
			t+=a * (6.0-float(xii));

		}
	}
	return vec3(t*.0008);
} //background color




//IQs RoundBox (try other objects http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm)
vec2 obj_roundBox(in vec3 p){
  return vec2(length(max(abs(p)-vec3(1,1,1),0.0))-0.25,1);
}

vec2 obj_sphere(in vec3 p){
  return vec2(length(p)-2.0);
}

//RoundBox with simple solid color
vec3 obj_roundBox_c(in vec3 p){
	return vec3(0.1,0.1,1.0);
}


//Objects union
vec2 inObj(in vec3 p){
    vec2 f = obj_floor(p);
    float b1 = torus(p+vec3(sin(time*0.77)*1.4,sin(time)*2.,cos(time)*5.),vec2(2.0,1.0));
    float b2 = sphere(p+vec3(cos(time)*4.4,cos(time)*2.,cos(time*1.2)*3.5),2.0);
    float b3 = sphere(p+vec3(sin(time)*3.6,sin(time*0.7)*2.,sin(time)*2.6),2.0);
    float b4 = sphere(p+vec3(cos(time*0.7)*4.4,sin(time*1.1)*2.,cos(time)*3.5),2.0);
    float b5 = sphere(p+vec3(sin(time*1.3)*3.6,cos(time*1.33)*2.,sin(time*0.94)*2.6),2.0);
    const float e = 0.1;
    const float r = 2.0;
    float b = 1.0/(b1+1.5+e)+1.0/(b2+r+e)+1.0/(b3+r+e)+1.0/(b4+r+e)+1.0/(b5+r+e);
    vec2 dist = ObjUnion(vec2(1.0/b-0.7, 1),f);
    //vec2 dist = vec2(1.0/b-0.7,1);
    return dist;
}

float ao(vec3 p, vec3 n, float d) {
	float s=sign(d);
	float o=s*.5+.5;
	for (float i=5.;i>0.;i--) {
		o-=(i*d-inObj(p+n*i*d*s).x)/exp2(i);
	}
	return o;
}

float shadow( in vec3 ro, in vec3 rd)
{
    float t;
    for(int i=1;i<130;i++)
    {
        float h = inObj(ro + rd*t).x;
        if( h<0.001 )
            return 0.0;
        t += h;
    }
    return 1.0;
}

float softshadow( in vec3 ro, in vec3 rd, float k )
{
    float res = 1.0;
    float t=1.0;
    for(int i=0;i<50;i++)
    {
        float h = inObj(ro + rd*t).x;
        res = min( res, k*h/t );
        t += h;
    }
    return res;
}
//Scene End

void main(void){
  //Camera animation
  vec3 U=vec3(0,1,0);//Camera Up Vector
  vec3 viewDir=vec3(0,0,0); //Change camere view vector here
  vec3 E=vec3(-sin(time*0.2)*8.0,4,cos(time*0.2)*8.0); //Camera location; Change camera path position here
  //vec3 E=vec3(mouse.x*4.0, 4, mouse.y*4.0); //Camera location; Change camera path position here
	
  //Camera setup
  vec3 C=normalize(viewDir-E);
  vec3 A=cross(C, U);
  vec3 B=cross(A, C);
  vec3 M=(E+C);
  
  vec2 vPos=2.0*gl_FragCoord.xy/resolution.xy - 1.0; // (2*Sx-1) where Sx = x in screen space (between 0 and 1)
  vec3 scrCoord=M + vPos.x*A*resolution.x/resolution.y + vPos.y*B; //normalize resolution in either x or y direction (ie resolution.x/resolution.y)
  vec3 scp=normalize(scrCoord-E);

  //Raymarching
  const vec3 e=vec3(0.001,0,0);
  const float MAX_DEPTH=30.0; //Max depth

  vec2 s=vec2(0.1,0.0);
  vec3 c,p,n,m,n1;
  vec2 l=vec2(1.0,0.0);	
	
  float f=1.0,g=1.0;
  for(int i=0;i<256;i++){
    if (abs(s.x)<.01||f>MAX_DEPTH) break;
    f+=s.x;
    g+=l.x;
    p=E+scp*f;
    m=E+scp*g;
    s=inObj(p);
    l=obj_floor(m);
  }	
n=normalize(
      vec3(s.x-inObj(p-e.xyy).x,
           s.x-inObj(p-e.yxy).x,
           s.x-inObj(p-e.yyx).x));

  if (f<MAX_DEPTH){
	  
    if (s.y==0.0)
      c=obj_floor_c(p);
    else
      c=obj_roundBox_c(p) + obj_floor_c(m+n)*(1.0-g*.03)*0.75*min(max(-(vPos.y-0.25),0.0),1.0);
    
    float b=max(dot(n,normalize(E-p)),0.1);
    gl_FragColor=vec4((b*c+pow(b,300.0))*(1.0-f*.03),1.0);//simple phong LightPosition=CameraPosition
    if(s.y==1.0)gl_FragColor -= max(0.5 - ao(p, n, 0.01),0.0);
    //if(s.y==1.0) gl_FragColor *= vec4(ao(p, n, -0.4));
    if(s.y==0.0)gl_FragColor -= max(0.25 - softshadow(p, n, 16.0),0.0);
  }
  else gl_FragColor=vec4(0,0,0,1); //background color
}