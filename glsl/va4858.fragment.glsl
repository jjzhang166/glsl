// simple 2D distance field visualizer
// designed for testing and debugging
// by @paniq
//
//
// move mouse to blend views:
// top left view: regular distance field
// top right view: gradient (normal) field
// bottom left view: final shape preview
// bottom right view: warp (first derivative of distance) field

#ifdef GL_ES
precision highp float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


// higher is sharper
const float CONTRAST= 1.0;
// higher is more dramatic
const float WARP_EMPHASIS= 1.0;
// higher is smaller
const float ZOOM= 0.5;
// gradient sampling delta
float DELTA= (3.0/resolution.y);

// comment for 2d
//#define RENDER3D


// math
//////

// useful transformations:
// abs(x) = max(x, -x)
// sqrt(a)*sqrt(b) = sqrt(a*b)
// cos(x) = cos(-x)
// -sin(x) = sin(-x)
// -tan(x) = tan(-x)
// cos(x - pi*0.5) = sin(x)
// sin(x + pi*0.5) = cos(x)
// tan(x) = sin(x)/cos(x)



vec2 noise(vec2 n) {
    vec2 ret;
    ret.x=fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453);
    ret.y=fract(cos(dot(n.yx, vec2(34.9865, 65.946)))* 28618.3756);
    return ret;
}

float saw(float v) {
    return mod(v, 1.0);
}

float tri(float v) {
    return abs(mod(v, 2.0) - 1.0);
}

float tris(float v) {
    return 1.0-abs(2.0-mod(v+1.0, 4.0));
}

const float LOG2= 0.6931471805599453;

float logscale(float v) {
    return pow(2.0, floor(log(v) / LOG2));
}
    
float logsaw(float v) {
    return v-pow(2.0, floor(log(v) / LOG2));
}

// built-in:
// float radians()

// some geometry tools
///////

float circle(vec2 d) {
    return length(d);
}

float hexagon(vec2 d)
{
    vec2 q = abs(d);
    float p = dot(q, vec2(0.866024,  0.5));
    return max(p, q.y);
}

float crossrect(vec2 d, vec2 s) {
    vec2 u = abs(d) - s;
    return min(u.x, u.y);
}

float rect(vec2 d, vec2 s) {
    vec2 u = abs(d) - s;
    return max(u.x, u.y);
}

// unsigned - causes problems in particular cases
float roundrect(vec2 d, vec2 s) {
    vec2 u = abs(d) - s;
    return length(max(u,0.0));
}

float outline(float d) {
    return abs(d);
}

// boolean operations
///////

float bool_union(float a, float b) {
    return min(a,b);
}

float bool_intersection(float a, float b) {
    return max(a, b);
}

float bool_subtraction(float a, float b) {
    return max(a,-b);
}

float morph(float a, float b, float n) {
    return mix(a, b, n);
}

// transforms
///////

vec2 translate(vec2 p, vec2 origin) {
    return p - origin;
}

vec2 rotate(vec2 p, float angle) {
    float c = cos(-angle);
    float s = sin(-angle);
    return vec2(
        p.x * c - p.y * s,
        p.y * c + p.x * s);
}

vec2 repeat(vec2 p, vec2 s) {
    vec2 c = s*0.5;
    return mod(p + c, s) - c;
}

// fold space along normal
vec2 fold(vec2 p, vec2 n) {
    return p - 2.0 * min(0.0, dot(p, n)) * n;
}

// fold space along angle
vec2 fold(vec2 p, float angle) {
    return fold(p, vec2(cos(angle), sin(angle)));
}

// this function can't be implemented
// vec2 scale(float (*func)(vec2), vec2 p, float s) {
//  return func(p / s) * s;
// }

// your custom evaluator here
//////

const float Scale = 2.0;
vec2 Offset = vec2(1.0, 0.58);

const int ITERS= 6;
float sierpinski(vec2 z)
{
    float r;
    
    for (int n = 0; n < ITERS; n++) {
       z = fold(z, radians(0.0));
       z = fold(z, radians(60.0));
       z = z*Scale - Offset*(Scale-1.0);
       z = rotate(z, radians(time*5.0));    
    }
    return (length(z) ) * pow(Scale, -float(ITERS)) - 0.015;
}

float triangle(vec2 p, float r) {
    return max((p.y + abs(p.x) * sqrt(3.0))*0.5, -p.y) - r;
}

const float pi = 3.14159;

float hexatiles(vec2 d) {
	d.x *= 0.8660254037844386;
	vec2 p = mod(d, vec2(3.0, 2.0));
	
	vec2 p0 = abs(p - vec2(1.5, 1.0));
	vec2 p1 = abs(p0 - vec2(1.5, 1.0));
	
	return min(max(p0.x + p0.y*0.5, p0.y),max(p1.x + p1.y*0.5, p1.y));
}

vec2 fisheye(vec2 p, float aperture) {
	float apertureHalf = 0.5 * aperture * (pi / 180.0);
  
  float maxFactor = sin(apertureHalf);
	
    float x = maxFactor * p.x;
    float y = maxFactor * p.y;
    
    float n = length(vec2(x, y));
    
    float z = sqrt(1.0 - n * n);
  
    float r = atan(n, z) / pi; 
  
    float phi = atan(y, x);

    float u = r * cos(phi) + 0.5;
    float v = r * sin(phi) + 0.5;

	return vec2(u,v);
}

float polar_coord_example(vec2 p) {
    
    float grid = hexatiles(fisheye(p/6.0, 90.0)*24.0)-0.9;
    return grid * 1.0;
}

float polar_distance(vec2 a, vec2 b) {
    return sqrt(a.x*a.x + b.x*b.x - 2.0*a.x*b.x*cos(a.y - b.y));
}

float ringslice(vec2 p, vec2 r, float a) {
    float d = length(p);
        float u = abs(d - r.s) - r.t;
    float v = abs(p.y * cos(a)) - p.x * sin(a);
    return max(u, v);
}

// de(x,y) = abs(fx-y) / sqrt(1.0 + pow(dfx / dx,2.0))

vec2 gridmod(vec2 p, out vec2 id) {
	id = floor(p);
	return (p - id);
}

float partitions(vec2 p) {
	vec2 id;
	vec2 n;
	
	vec2 no = vec2(1.0, 1.0);
	n = no;
	//p *= no;
	id = floor(p);
	
	no = (1.0 + floor(noise(id*1.0241) * 5.0));
	n *= no;	
	p *= no;
	id = floor(p);
	
	no = (2.0 + floor(noise(id*1.71 + 73.151) * 2.0));
	n *= no;
	p *= no;
	id = floor(p);
	
	no = (1.0 + floor(noise(id*7.39 + 41.3) * 4.0));
	n *= no;
	p *= no;
	id = floor(p);
	
	no = (1.0 + floor(noise(id*3.31337 + 7.01) * 3.0));
	n *= no;
	p *= no;
	id = floor(p);
	
	p -= id;

    	vec2 u = (abs(p - 0.5) - 0.5) / n;
	return max(u.x, u.y);
}

// final evaluator
float position_to_distance(vec2 p) {
    	return -(partitions(p - mouse*16.0));
}

// 3d converter
float position_to_distance(vec3 o) {
	/*
	float r = length(o);
	float phi = acos(o.y / r) / pi;
	float rho = atan(o.z, o.x) / pi;
	
	float pattern = hexatiles(vec2(phi*32.0,rho*32.0));
	float sph = r - (6.0 - max(pattern, 0.6)*0.3);
	*/
	vec3 q = abs(o) - 3.0;
	float cube = max(max(q.x,q.y),q.z);
	return max(partitions(o.xy / 4.0)*4.0 + 0.03, cube);
}

// engine
///////
        

// gradient function
vec2 position_to_normal(vec2 p) {
    return normalize(vec2(
        position_to_distance(vec2(p.x+DELTA, p.y)) - position_to_distance(vec2(p.x-DELTA, p.y)),
        position_to_distance(vec2(p.x, p.y+DELTA)) - position_to_distance(vec2(p.x, p.y-DELTA))
    ));
}

// warp function
float position_to_warp(vec2 p) {
    return length(vec2(
        (position_to_distance(vec2(p.x+DELTA, p.y)) - position_to_distance(vec2(p.x-DELTA, p.y))),
        (position_to_distance(vec2(p.x, p.y+DELTA)) - position_to_distance(vec2(p.x, p.y-DELTA)))
    ) / (2.0*DELTA));
}

float fixed_position_to_distance(vec2 p) {
    float warp = position_to_warp(p);
    float distance = position_to_distance(p);
    return distance / warp;
}


// distance field shader
// by default, full red is exactly 0, full blue is >= 1, full green is <= -1
vec3 distance_to_color(float d) {
    d *= CONTRAST;
    
    float border = clamp(1.0 - abs(d), 0.0, 1.0);
    float inside = max(-d, 0.0);
    float outside = max(d, 0.0);
    
    return vec3(inside, border, outside);
}

// distance field outline shader
vec3 shade_color(float d) {
    float s = d * (resolution.y / 3.0);
    return vec3(s);
}
    
// gradient field shader
vec3 normal_to_color(vec2 n) {
    n = (n + 1.0) / 2.0;
    return vec3(n.x, n.y, 0.5);
}

// warp field shader
// green: perfect (~1)
// red: distance too large (> 1), need scale down
// blue: distance too small (< 1), need scale up
vec3 warp_to_color(float w) {
    w = (w - 1.0) * WARP_EMPHASIS;
    
    float perfect = clamp(1.0 - abs(w), 0.0, 1.0);
    float toosmall = max(-w, 0.0);
    
    if (w <= -1.0)
	    return vec3(1.0, 0.6, 0.0);
    if (w > 0.001)
	    return vec3(1.0, 0.0, 0.0);
    return vec3(0.0, perfect, toosmall);
}

void render_2d() {
    vec2 proj = vec2(resolution.x * ZOOM / resolution.y, ZOOM);
    vec2 position = (( gl_FragCoord.xy / resolution.xy )*2.0 - 1.0) * proj;
    
    vec2 axis = vec2(0.0, 0.0); //clamp(mouse * 2.0 - 0.5, 0.0, 1.0);

    vec3 distance_color = clamp(distance_to_color(position_to_distance(position)), 0.0, 1.0);
    vec3 normal_color = clamp(normal_to_color(position_to_normal(position)), 0.0, 1.0);
    vec3 fixed_color = clamp(shade_color(position_to_distance(position)), 0.0, 1.0);
    vec3 warp_color = clamp(warp_to_color(position_to_warp(position)), 0.0, 1.0);
    
    vec3 color = mix(
        mix(fixed_color, warp_color, axis.x),
        mix(distance_color, normal_color, axis.x),
        axis.y);
    
    gl_FragColor = vec4(color, 1.0);

}

void render_3d() {
	vec2 p = -1. + 2.*gl_FragCoord.xy / resolution.xy;
	p.x *= resolution.x/resolution.y;
	
	//Camera animation
  vec3 vuv=vec3(0,1,0);//Change camere up vector here
  vec3 vrp=vec3(0,1,0); //Change camere view here
  vec3 prp=vec3(sin(time*0.3)*8.0,4,cos(time*0.3)*8.0); //Change camera path position here

  //Camera setup
  vec3 vpn=normalize(vrp-prp);
  vec3 u=normalize(cross(vuv,vpn));
  vec3 v=cross(vpn,u);
  vec3 vcv=(prp+vpn);
  vec3 scrCoord=vcv+p.x*u+p.y*v;
  vec3 scp=normalize(scrCoord-prp);

  //Raymarching
  const vec3 e=vec3(0.03,0,0);
  const float maxd=32.0; //Max depth

  float s=0.1;
  vec3 c,p1,n;

  float f=1.0;
  float steps = 1.0;
	
  for(int i=0;i<32;i++){
   // if (abs(s)<.01||f>maxd) {
//	    steps = float(i)/32.0;
//	    break; 
  //  }
    f+=s;
    p1=prp+scp*f;
    s=position_to_distance(p1);
  }
  	
	//replacing if/else with ternary to try out with apple's "core image"
	c=vec3(.5,0.5,0.5);
    	n=normalize(
      	vec3(s-position_to_distance(p1-e.xyy),
           s-position_to_distance(p1-e.yxy),
           s-position_to_distance(p1-e.yyx)));
    	float b=dot(n,normalize(prp-p1));
    	vec4 tex=vec4(0.3,0.3,0.3,1.0) + vec4((b*c+pow(b,8.0))*(1.0-f*.01),1.0);
	vec4 background=vec4(0,0,0,1);
	
	vec4 Color=(f<maxd)?tex:background;
	Color.rgb *= 1.0 - steps*0.5;
	Color.r = smoothstep(0.0, 1.0, Color.r);
	Color.g = max(smoothstep(-0.1, 1.0, Color.b), 0.0);
	
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
//to use with core image, just replace with "return Color"
gl_FragColor=Color;	
}

void main() {

	render_2d();

}
