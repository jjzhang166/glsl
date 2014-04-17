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
  float spread=1.0;
  float total=0.0;
  float delta=0.01;
  float cameraZ=-1.5;
  float nearZ=-1.0;
  float farZ=1.0;
  vec3 col=vec3(0.0,0.0,0.0);
  vec3 ray=vec3(0.0,0.0,0.0);
  mat3 rot=genRotMat(sin(time/4.13)*360.0,1.0,0.0,0.0);
  rot=rot*genRotMat(sin(time/4.64)*360.0,0.0,1.0,0.0);
  rot=rot*genRotMat(sin(time/4.24)*360.0,0.0,0.0,1.0);
  vec2 pos;
  pos.x=gl_FragCoord.x/resolution.y-0.5*resolution.x/resolution.y;
  pos.y=gl_FragCoord.y/resolution.y-0.5;
  ray.xy+=pos.xy*spread*(nearZ-cameraZ);
  vec3 rayDir=vec3(spread*pos.xy*delta,delta);
  ray.z=nearZ;
  for(int i=0;i<200;i++){
    if(ray.z>=farZ)break;
    vec3 temp;
    float val;
    temp=ray.xyz*rot;
    val=cubeDist(temp);
    total+=val*delta*1.2;
    col.x+=abs(temp.x*delta);
    col.y+=abs(temp.y*delta);
    col.z+=abs(temp.z*delta);
    ray+=rayDir;
  }
  gl_FragColor=vec4(col.xyz*total,1.0);
  //gl_FragColor=vec4(pos.x,pos.y,0.0,1.0);
}