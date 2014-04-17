#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec4 mouse;

// blobsphere - with bump and lightsource
// quite light - c version even worked on my dumb Radeon Xpress
// KRABOB^MKD aka vic ferry, 2009 - first release 3/12/2010
void main(void)
{
  vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
  
  // -------- the uniform that were C coded by frame: ----
  float uSphereRay=(30.0 +mouse.y*10.0/resolution.y +sin(time*0.75)*1.5)*1.3; // sphere ray
  float ngl1= mouse.x*6.0/resolution.x; //time*0.3; // apply same rotation on light and screen
  float rotsin = sin(ngl1 );
  float rotcos = cos(ngl1 );
  vec3 l1Pos =vec3( -rotcos*2.0 ,0.8,-rotsin*2.0 );
  vec3 l1Color = vec3(0.9,0.8,0.8);
  float fov=0.35; // field of vision  - more wide angle if close to 0
 
  // -------- the frag itself
  // get a raytace vector
  vec3 direction = vec3(p.x*rotsin-fov*rotcos,p.y,p.x*rotcos+fov*rotsin);
  // no rotation version: vec3 direction = vec3(p.x,p.y,fov);
  vec3 normDir = normalize(direction ); // gives a sphere
  vec3 normDirMagnified = normDir*uSphereRay;
  // apply a turbulence(x,y,z) on the sphere surface
  vec3 turbsin = sin(normDirMagnified);
  vec3 turbcos = cos(normDirMagnified);
  vec3 turbuledDir = turbsin.xyz*turbcos.yzx;
  // compute both value and derivate :)
  vec4 valueNorm;       
  valueNorm.w =  turbuledDir.x+turbuledDir.y+turbuledDir.z;         
  valueNorm.x = turbcos.x*turbcos.y - turbsin.x*turbsin.z;
  valueNorm.y = turbcos.y*turbcos.z - turbsin.y*turbsin.x;
  valueNorm.z = turbcos.z*turbcos.x - turbsin.z*turbsin.y;
  // some magics to make the lightning
  vec3 finalnormal = normalize(normDir*0.5+valueNorm.xyz*0.16);
  float magicval = 0.75+abs(valueNorm.w*0.25);
  float light1 = dot( finalnormal, normalize(normDir-l1Pos) );
  light1 *= magicval;
  light1 = max(0.15,light1);
  vec3 color = mix(l1Color,vec3(0.3,0.2,0.4),0.25+valueNorm.w*0.25);

  gl_FragColor=vec4(color*light1,1.0);
}