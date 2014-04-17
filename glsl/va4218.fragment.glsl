#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

mat3 genRotMat(float a0,float x,float y,float z){
float a=a0*3.1415926535897932384626433832795/180.0;
  return mat3(
    1.0+(1.0-cos(a))*(x*x-1.0),
    -z*sin(a)+(1.0-cos(a))*x*y,
    y*sin(a)+(1.0-cos(a))*x*z,
    z*sin(a)+(1.0-cos(a))*x*y,
    1.0+(1.0-cos(a))*(y*y-1.0),
    -x*sin(a)+(1.0-cos(a))*y*z,
    -y*sin(a)+(1.0-cos(a))*x*z,
    x*sin(a)+(1.0-cos(a))*y*z,
    1.0+(1.0-cos(a))*(z*z-1.0)
  );
}

float cubeDist(vec3 p){
  float t0=0.5;
  float t1=0.51;
  float max=max(abs(p.x),max(abs(p.y),abs(p.z)));
  if(max>t1) return 0.0;
  else if(max>t0) return (t1-max)/(t1-t0);
  else return 1.0;
}

void main(){
  float spread=0.5;
  float total=-0.0;
  float delta=0.01;
  float cameraZ=-3.0;
  float nearZ=-1.0;
  float farZ=1.0;
  vec3 col=vec3(0.0,0.0,0.0);
  vec3 ray=vec3(0.0,0.0,0.0);
  mat3 rot=genRotMat(sin(time/4.13)*360.0,1.0,0.0,0.0);
  rot=rot*genRotMat(sin(time/4.64)*360.0,0.0,1.0,0.0);
  rot=rot*genRotMat(sin(time/4.24)*360.0,0.0,0.0,1.0);
  mat3 rot2 = genRotMat(sin(time/3.24)*360.0,0.0,0.0,1.0);
  rot2 = rot2 * genRotMat(sin(time/3.64)*360.0,0.0,0.0,1.0);
  mat4 tra1 = mat4(1,0,0,0.5, 0,1,0,0 ,0,0,1,0 ,0,0,0,0);
  mat4 tra2 = mat4(1,0,0,-0.2, 0,1,0,0.5 ,0,0,1,0 ,0,0,0,0);
  vec2 pos;
  pos.x=gl_FragCoord.x/resolution.y-0.5*resolution.x/resolution.y;
  pos.y=gl_FragCoord.y/resolution.y-0.5;
  ray.xy+=pos.xy*spread*(nearZ-cameraZ);
  vec3 rayDir=vec3(spread*pos.xy*delta,delta);
  ray.z=nearZ;
  for(int i=0;i<200;i++){
    if(ray.z>=farZ)break;
    vec3 temp, temp2;
    float val, val2;

    temp=ray.xyz*rot;
    temp2=ray.xyz*rot2;
    temp = vec3(vec4(temp,1.0) * tra1);
    temp2 = vec3(vec4(temp2,1.0) * tra1);
    val=cubeDist(temp);
    val2=cubeDist(temp2);
	  if (val>0.0) {
		  col = temp + rayDir*ray.z;
		  break;
	  }
	  if (val2>0.0) {
		  col = temp + rayDir*ray.z;
		  col = 1.0 - col;
		  break;
	  }
    total+=delta*1.0;
    col.x+=val;//abs(temp.x*delta);
    // col.y+=abs(temp.y*delta);
    col.z+=val2;//abs(temp.z*delta);
    ray+=rayDir;
  }
  gl_FragColor=vec4(col.xyz*total,1.0);
  //gl_FragColor=vec4(pos.x,pos.y,0.0,1.0);
}