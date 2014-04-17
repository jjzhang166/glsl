// Fixed shadows and ambient occlusion bugs, and sped some shit up.
// Still needs some work
// Voltage / Defame (I just fixed some bugs, someone else did they main work on this)
// rotwang: @mod* tinted shadow
// modded by @dennishjorth. A few opts, just with the blue color, metafied blobby toruses are pretty neat.

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

//Scene Start

//Torus
float torus(in vec3 p2, in vec2 t, float offset, float modder){
	vec3 p = vec3(
		(sin(offset+time*modder*0.14+0.5+sin(p2.y*p2.y*0.3+p2.z*p2.z*0.3+2.0+time*modder*0.14))*0.4+1.0)*p2.x,
		(sin(offset+time*modder*0.15+1.0+sin(p2.x*p2.x*0.3+p2.z*p2.z*0.3+1.5+time*modder*0.15))*0.4+1.0)*p2.y,
		(sin(offset+time*modder*0.13+1.5+sin(p2.x*p2.x*0.3+p2.y*p2.y*0.3+0.5+time*modder*0.12))*0.4+1.0)*p2.z
		);	
	vec2 q = vec2(length(vec2(p.x,p.z))-t.x, p.y);
	return length(q) - t.y;
}

//Objects union
vec2 inObj(in vec3 p){
    const float modder = 0.1;
    float cos1x = cos(time*modder*5.0);
    float sin1x = sin(time*modder*5.0);
    float cos2x = cos(time*modder*4.0);
    float sin2x = sin(time*modder*4.0);
    float cos3x = cos(time*modder*5.5);
    float sin3x = sin(time*modder*5.5);
    float cos4x = cos(time*modder*4.5);
    float sin4x = sin(time*modder*4.5);

    vec3 p3 = vec3(p.x*cos1x+p.z*sin1x,
	    p.y,
	    p.x*sin1x-p.z*cos1x);

    vec3 p4 = vec3(p.x*cos3x+p.z*sin3x,
	    p.y,
	    p.x*sin3x-p.z*cos3x);

   vec3 p5 = vec3(p4.x,
	    p4.y*cos4x+p4.z*sin4x,
	    p4.y*sin4x-p4.z*cos4x);
	
   vec3 p6 = vec3(p3.x,
	    p3.y*cos2x+p3.z*sin2x,
	    p3.y*sin2x-p3.z*cos2x);

    float b1 = torus(p5+vec3(cos(time*modder*0.37)*3.33,sin(time*modder*0.69)*0.33,cos(time*modder*0.79)*0.33),vec2(3.0,1.0),0.5,modder);
    float b2 = torus(p3+vec3(sin(time*modder*0.57)*3.33,cos(time*modder*0.74)*0.33,cos(time*modder*0.64)*0.33),vec2(3.0,1.0),1.0,modder);
    float b6 = torus(p6+vec3(sin(time*modder*0.47)*3.33,cos(time*modder*0.94)*0.33,cos(time*modder*0.84)*0.33),vec2(3.0,1.0),1.5,modder);
    const float e = 0.1;
    const float r = 2.0;
    float b = 1.0/(b1+1.0+e)+1.0/(b2+1.0+e)+1.0/(b6+1.0+e);
    vec2 dist = vec2(1.0/b-0.7,1);
    return dist;
}

//Scene End

void main(void){
  //Camera animation
  vec3 U=vec3(0,1,0);//Camera Up Vector
  vec3 viewDir=vec3(0,0,0); //Change camere view vector here
  vec3 E=vec3(-sin(time*0.2)*8.0,cos(time*0.15)*4.0,cos(time*0.2)*8.0); //Camera location; Change camera path position here
	
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
  const float MAX_DEPTH=15.0; //Max depth

  vec2 s=vec2(0.1,0.0);
  vec3 c,p,n;
	
  float f=1.0;
  for(int i=0;i<192;++i){
    if (abs(s.x)<.01||f>MAX_DEPTH) break;
    f+=s.x;
    p=E+scp*f;
    s=inObj(p);
  }	
  n=normalize(
      vec3(s.x-inObj(p-e.xyy).x,
           s.x-inObj(p-e.yxy).x,
           s.x-inObj(p-e.yyx).x));

  if (f<MAX_DEPTH){
    c=vec3(1.0,0.1,0.4);
	  c.x = c.x*sin(f+cos(f+time*1.2)+time*1.1)*0.4;
	  c.y = 0.1;
	  c.z += cos(f+sin(f+time*2.1)+time*3.3)*0.2;
	  c.x += 0.2;
	  c.z += 0.4;
    float b=max(dot(n,normalize(E-p)),0.1);
    gl_FragColor=vec4((b*c+pow(b,100.0))*(1.0-f*.001),1.0);//simple phong LightPosition=CameraPosition
  }
  else gl_FragColor=vec4(0,0,0.0,1); //background color
}