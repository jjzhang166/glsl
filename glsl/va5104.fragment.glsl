// Tease
//http://mrdoob.com/projects/glsl_sandbox/#A/5d00000100cf0800000000000000119a48c65ab5aec1f910f780dfdfe473e599a211a90304ab6a650a0bdc710e60d9ef6827f7e37c460aba047c4de9e20bce74e61fe18eb9c973038e14aa900e8e6d4e503e9118e90920fe9c659f66293e2eb43d2efdae04d24cd9d333bb5a9baf075db9391f2a11ffdea9717773e9c63b13f2916baccf7f2282161c46b91553326c1ecec44aa673a105a52397b06fc30600f1844900105b00751e0b3e362af10b67968e219073e2186076d15ceb4d3a41608ad0965efaf9d56da7db7283ae3bc1871dc0f38642229ca44b767e948d301cdcaf7814a0b971b3c2607bbd03d7b43cee6b3fc7d193415170c6e8a0b99ecfb4c406e08f4f3b2fa3e0f7d53bff49c6e528574f0af8f6d44ac1a306e721009683a0711c0a345cf5fa3a26d1835e49c5719334c35a5f2ed8b6cd95c57949ec1780138ba9acbe502d1f89ec3fb2154e3be3a94090a7ce4aca524bb5285f4d81addb2edf5768bb5529d8369c450353a37f5b64876d5af50b0918443e8f6cc2bb6f113c1b61f81ae08e641a553b45a27ea2f2c0d0bb30427411a4c119989a8503e7671906f75dbd53341af0d89d3f1c563368ef9ac75afaa5f764118676b5916beae329cf042fdfce698a0087c29638d1a7eefb0882e3a3ad2522f118b486503a08fde02cd89a992587062bf8a8f74d52f6a4c0074b5d692551838487879cdbda524d5f8750b64a5db87797c8ee7f17e2cead5c44d5a7ad51fdd687505e63862583a3676be6001311aa4f8da3d62cbe9048640c5df10f77d0c57a54bdd5f2d8b473263f0939590e7e960e96c1d2c3176bf7e70231a56866c66189da4a486651cbcc9039ea317a446b16399a68fbb088d0de0bc7fe1ad8d74f703cfff7203f31083fd2aec1e459a3ce77b1f2c0027658e36dc159ea0f7b3fdfc8b0ddeb164e6c6d5b105148092a4d4155e1e0a138e2d54c3a7184bdb48840b3e5b25f9ce1becfa91abc7d5bd776d95c012a0e8b956a3333e4823e44732e957926f6f6d5bee384d042868b4429ceb26a33b1cc443d949b82309ed086062db73e4492b62bcc59cfae9199f46f4ea34ba3a0b211a384ac21cb25b177ba8a2b5416fd16f27781a6ead997b74b6d245c4f46004fff7d7c7f02e4b053e50083b83ad60fc11022ad05f285dd9607435340e038b3867ffc89b1414bcfc77a8bfa11ba00e8f5e263624bd060556919a872ff95bf5c919d149a159105eea58e855c7c0d92f1497342528620e346b2a60b9334cf0e2e8ef285cbc0dfbbcfbd4f160412e4cf7b6c855d75f40181cb3934d0ee6ecf6114fd150bfc0ff39106fae7bd81214c206504e20e92f4ff1a7908665fe57826fe7cf5f07cc78de092c14d04946300f316e9adff392976e502cd078e9cfb3da37c07a86cb8cd2bb729738fe8cc33253298835e2df8b390e3db7ad435d613d6300bb8d880b0b4ae5786615fd3408247ef6a6cff5471cd00

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

/*
 * Description : Array and textureless GLSL 2D/3D/4D simplex 
 *               noise functions.
 *      Author : Ian McEwan, Ashima Arts.
 *  Maintainer : ijm
 *     Lastmod : 20110822 (ijm)
 *     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
 *               Distributed under the MIT License. See LICENSE file.
 *               https://github.com/ashima/webgl-noise
 */ 

vec4 _mod289(vec4 x)
{
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 _mod289(vec3 x)
{
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 _mod289(vec2 x) 
{
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

float _mod289(float x)
{
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}
  
vec4 _permute(vec4 x)
{
    return _mod289(((x*34.0)+1.0)*x);
}

vec3 _permute(vec3 x)
{
    return _mod289(((x*34.0)+1.0)*x);
}

float _permute(float x) 
{
    return _mod289(((x*34.0)+1.0)*x);
}

vec4 _taylorInvSqrt(vec4 r)
{
    return 1.79284291400159 - 0.85373472095314 * r;
}

float _taylorInvSqrt(float r)
{
    return 1.79284291400159 - 0.85373472095314 * r;
}

vec4 _grad4(float j, vec4 ip)
{
    const vec4 ones = vec4(1.0, 1.0, 1.0, -1.0);
    vec4 p,s;

    p.xyz = floor( fract (vec3(j) * ip.xyz) * 7.0) * ip.z - 1.0;
    p.w = 1.5 - dot(abs(p.xyz), ones.xyz);
    s = vec4(lessThan(p, vec4(0.0)));
    p.xyz = p.xyz + (s.xyz*2.0 - 1.0) * s.www; 

    return p;
}
  
/*
 * Implemented by Ian McEwan, Ashima Arts, and distributed under the MIT License.  {@link https://github.com/ashima/webgl-noise}
 */  
float snoise(vec2 v)
{
    const vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                        0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                       -0.577350269189626,  // -1.0 + 2.0 * C.x
                        0.024390243902439); // 1.0 / 41.0
    // First corner
    vec2 i  = floor(v + dot(v, C.yy) );
    vec2 x0 = v -   i + dot(i, C.xx);

    // Other corners
    vec2 i1;
    //i1.x = step( x0.y, x0.x ); // x0.x > x0.y ? 1.0 : 0.0
    //i1.y = 1.0 - i1.x;
    i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
    // x0 = x0 - 0.0 + 0.0 * C.xx ;
    // x1 = x0 - i1 + 1.0 * C.xx ;
    // x2 = x0 - 1.0 + 2.0 * C.xx ;
    vec4 x12 = x0.xyxy + C.xxzz;
    x12.xy -= i1;

    // Permutations
    i = _mod289(i); // Avoid truncation effects in permutation
    vec3 p = _permute( _permute( i.y + vec3(0.0, i1.y, 1.0 )) + i.x + vec3(0.0, i1.x, 1.0 ));

    vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
    m = m*m ;
    m = m*m ;

    // Gradients: 41 points uniformly over a line, mapped onto a diamond.
    // The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)
    vec3 x = 2.0 * fract(p * C.www) - 1.0;
    vec3 h = abs(x) - 0.5;
    vec3 ox = floor(x + 0.5);
    vec3 a0 = x - ox;

    // Normalise gradients implicitly by scaling m
    // Approximation of: m *= inversesqrt( a0*a0 + h*h );
    m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );

    // Compute final noise value at P
    vec3 g;
    g.x  = a0.x  * x0.x  + h.x  * x0.y;
    g.yz = a0.yz * x12.xz + h.yz * x12.yw;
    return 130.0 * dot(m, g);
}

//Util Start
vec2 ObjUnion(in vec2 obj0,in vec2 obj1, out vec2 obj){
	obj = vec2(0,0);
  if (obj0.x<obj1.x)
  {
	obj.x = 1.0;
  	return obj0;
  }
  else
  {
	  obj.y = 1.0;
  	return obj1;
  }
}
//Util End

//Scene Start

//Floor
vec2 obj0(in vec3 p){
  float noise = snoise(p.xy * 2.0);
  return vec2(p.y+5.0,0);
}
//Floor Color (checkerboard)
vec3 obj0_c(in vec3 p){
 if (fract(p.x*.5)>.5)
   if (fract(p.z*.5)>.5)
     return vec3(0,0,0);
   else
     return vec3(1,1,1);
 else
   if (fract(p.z*.5)>.5)
     return vec3(1,1,1);
   else
     	return vec3(0,0,0);
}

//IQs RoundBox (try other objects http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm)
vec2 obj1(in vec3 p){
  return vec2(length(max(abs(p)-vec3(1,1,0.7),0.0))-0.45,1);
}

//RoundBox with simple solid color
vec3 obj1_c(in vec3 p){
	return vec3(1.0,0.5,0.2);
}

float sdSphere( vec3 p, float s )
{
  return length(p)-s;
}

vec3 sphereColor(vec3 p)
{
	return vec3(0,0,0.5);
}

float length8(vec2 val)
{
	return pow(pow(val.x, 2.0)+pow(val.y, 2.0),(1.0/2.0));
}

float sdTorus88( vec3 p, vec2 t )
{
  vec2 q = vec2(length8(p.xy)-t.x,p.z);
  return length8(q)-t.y;
}

vec3 torusColor(vec3 p)
{
	return vec3(0,0.5,0);
}

float displacement(vec3 p)
{
	return sin(1.0*p.x)*sin(2.0*p.y)*sin(2.0*p.z);
}

float udRoundBox( vec3 p, vec3 b, float r )
{
  return length(max(abs(p)-b,0.0))-r;
}

//Objects union
vec2 inObj(vec3 p, out vec3 color){
	vec2 obj;
	int objId = 0;
	
//vec3 c = vec3(2.5,0.1,0.1);
    //p = mod(p,c)-0.5*c;
    //return primitve( q );

	mat3 m = mat3(cos(time),0.0,sin(time), 0.0,1.0,0.0, -sin(time),0,cos(time));
	//mat3 m = mat3(cos(3.14),0.0,sin(3.14), 0.0,1.0,0.0, -sin(3.14),0,cos(3.14));
	//mat3 m = mat3(1);
	vec3 tempP= p;
	p.xy += 3.0*mouse.xy;
	p = m*p;
  vec2 result =  ObjUnion(obj0(p),obj1(p), obj);
	if (obj.y >0.2 )
		objId = 1;
	result = ObjUnion(vec2(sdSphere(p-vec3(0,1.45,-0.05),1.05),0), result, obj);
	if (obj.x > 0.2)
		objId = 2;
	result = ObjUnion(vec2(sdTorus88(p-vec3(0.05,0.05,0.75),vec2(0.75,0.55)),0), result, obj);
	if (obj.x > 0.2)
		objId = 3;
	result = ObjUnion(vec2(udRoundBox(p-vec3(0.85,-2.5,-0.15), vec3(0.001,1.4,0.1), 0.45 ),0), result, obj);
	if (obj.x > 0.2)
		objId = 4;
	result = ObjUnion(vec2(udRoundBox(p-vec3(-0.85,-2.5,-0.15), vec3(0.001,1.4,0.1), 0.45 ),0), result, obj);
	if (obj.x > 0.2)
		objId = 5;
	
	//mat4 handRot = mat4(1.0,0.0,0.0, 0.0,cos(0.*time),-sin(0.1*time), 0.0, sin(0.1*time),cos(0.1*time));
	vec3 handCenter1 = vec3(-2.25,0.9,0.25);
	//handCenter1 = handRot*handCenter1;
	result = ObjUnion(vec2(udRoundBox(p-handCenter1, vec3(0.91,0.01,0.1), 0.45 ),0), result, obj);
	if (obj.x > 0.2)
		objId = 6;
	result = ObjUnion(vec2(udRoundBox(p-vec3(2.25,0.9,0.25), vec3(0.91,0.01,0.1), 0.45 ),0), result, obj);
	if (obj.x > 0.2)
		objId = 7;
	
	if (objId == 0)
		result = ObjUnion(obj0(tempP),obj0(tempP),obj);
	
	if (objId == 6 || objId == 7)
		color = vec3(0.65, 0.1, 0.41);
	else if (objId == 4 || objId == 5)
		color = vec3(0.65, 0.1, 0.41);
	else if (objId == 3)
		color = torusColor(p);
	else if (objId == 2)
		color = sphereColor(p);
	else if (objId == 1)
		color = vec3(0.5, 0.5, 0);
	else if (objId == 0)
	{
		color = obj1_c(p);
	}
	
		if (objId == 0)
		result.x += 0.2*displacement(p);
	return result;
}

//Scene End



void main(void){
  vec2 vPos=-1.0+2.0*gl_FragCoord.xy/resolution.xy;

  //Camera animation
  vec3 vuv=vec3(0,1,0);//Change camere up vector here
  vec3 vrp=vec3(0,0,0); //Change camere view here
  vec3 prp=vec3(-sin(0.0)*8.0,4,cos(0.0)*8.0); //Change camera path position here

  //Camera setup
  vec3 vpn=normalize(vrp-prp);
  vec3 u=normalize(cross(vuv,vpn));
  vec3 v=cross(vpn,u);
  vec3 vcv=(prp+vpn);
  vec3 scrCoord=vcv+vPos.x*u*resolution.x/resolution.y+vPos.y*v;
  vec3 scp=normalize(scrCoord-prp);
	
  //Raymarching
  const vec3 e=vec3(0.1,0,0);
  const float maxd=60.0; //Max depth

  vec2 s=vec2(0.1,0.0);
  vec3 c,p,n;
vec3 color;
  float f=1.0;
  for(int i=0;i<256;i++){
    if (abs(s.x)<.01||f>maxd) break;
    f+=s.x;
    p=prp+scp*f;
    s=inObj(p, color);
  }
  
  if (f<maxd){
    //if (s.y==0.0)
     // c=obj0_c(p);
    //else
      c=obj1_c(p);
	  vec3 tempColor;
    n=normalize(
      vec3(s.x-inObj(p-e.xyy, tempColor).x,
           s.x-inObj(p-e.yxy, tempColor).x,
           s.x-inObj(p-e.yyx, tempColor).x));
    float b=dot(n,normalize(prp-p));
    gl_FragColor=vec4((b*color+pow(b,8.0))*(1.0-f*.01),1.0);//simple phong LightPosition=CameraPosition
  }
  else gl_FragColor=vec4(0,0,0,1); //background color
}