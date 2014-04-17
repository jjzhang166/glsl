#ifdef GL_ES
precision highp float;
#endif

#define PI  3.1415926
#define TAU 6.2831853
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//props to the parent + iq + etc.
//clean up and lighting tweaks
//sphinx

vec3 ray(vec2 pixel, vec3 pos, vec3 target);
float map(vec3 p);

float bricks(vec3 p);
float tile(vec3 p);
	
float sphere(vec3 p,  float radius);
float cone( vec3 p, vec2 c );
float cylinder( vec3 p, vec3 c, float l);
float tube( vec3 p, vec3 c );
float cube(vec3 v, vec3 size, vec3 position);
float torus(vec3 p, vec2 t);
float plane(vec3 p, vec4 n);

float blend(float d1, float d2);
float intersect(vec3 ro, vec3 rd);

vec3 norm(vec3 p);
vec3 rotate(vec3 p, vec3 v, float a);
vec3 mrotate(vec3 p);

float hash(vec2 co);
float noise(vec2 p, float s);
float mix2(float a2, float b2, float t2);
float fractnoise(vec2 p, float s, float c);


void main( void ) {

	vec2 p = gl_FragCoord.xy/resolution.xy;
	p = -1.0 + 2.0*p;
	p.x *= resolution.x/resolution.y;
	
	vec3 lookat = vec3(0.0,8.0, -25.0);
	vec3 ro = vec3(0.0, 0.0, 0.0); //camera position
	vec3 rd = ray(p, ro, lookat); 

	//store the final color in the FragColor
	float t = intersect(ro, rd);
	vec3 lpos = vec3(1., 1., 1.) + rotate(vec3(0.0, 10.0, 25.0), vec3(0.0, 1.0, 0.0), time*50.0);
	
	vec3 result;
	if(t  >= 0.0){
		vec3 p = ro + rd * t;
		vec3 l = normalize(lpos - p);
		
		vec3 n = norm(ro + rd*t);
		float nl = max(0.0, dot(n,l));
		float ndote = max(dot(n, -rd), 0.0);
		vec3 er = normalize(rd +2.0*ndote*n);
	
		vec3 cLight = vec3(.9, .9, .7);
		vec3 light = vec3(nl) * cLight;
				
		float shine = 9.;
		vec3 cSpec = vec3(.7, .7, .8);
		vec3 spec = pow(max(dot(l,er), 0.), shine) * cSpec;
		
		vec3 ambient = .1 + vec3(.2, .2, .15);
		
		
		vec3 mat = .5 * n + vec3(.75);
		
		float fresnel = nl * clamp(cos(dot(rd, n)), 0., 1.); //cheating...
		fresnel *= fresnel;
		
		float fog = min(-.1, t/32.);
		
		float b = .2 * clamp(intersect(p, n), 0., 1.);
		vec3 rv = normalize(rd - n * .15);
		float i = clamp(intersect(p+rd*.25, rv), -1., 1.);
		i += clamp(intersect(p+rv*i+.01, normalize(rd - n * -.15)), -0.5, .5);
		//needs shadows, ao... 
		
		//i *= fresnel;
		light = light + spec + ambient - clamp(fog / fresnel, 0., 1.);
		
		result = i * mat * fresnel + mat * light + b * light + fog;
	}else{
		vec3 cBG = vec3(0.0, 0.0, 0.0);
		
		result = cBG;
	}
	
	gl_FragColor = vec4(result, 0.);
}


float map(vec3 p){
	float r;
	
	vec3 mp = p + vec3(0., -.15, .65);
	
	mp = rotate(mp, vec3(0., 1., 0.), 90.);	
	mp = mrotate(mp);

	float s0 = length(mp)-.22;
	
	//~iq's twist + some blah
	float v = cos(time * .31)* PI * 5.;
	
	float l = length(mp);
			
	float c = cos(v * l - mp.x);
  	float s = sin(v * l - mp.x);
  	mat2  m = mat2(c,-s,s,c);
		
  	mp = vec3(m*mp.yz,mp.x) * .5;

	c = cos(v * l * mp.y);
  	s = sin(v * l * mp.y);
  	m *= mat2(c,-s,s,c);
		
	mp = vec3(m*mp.xz,mp.y) * .5;
	
	c = cos(v * l * mp.z);
  	s = sin(v * l * mp.z);
  	m *= mat2(c,-s,s,c);
		
	mp = vec3(m*mp.xy,mp.z) * .5;
	
	float c0 = cube(mp, vec3(.5, .00001, .5), vec3(0.));	
	r = max(c0, s0);
	
	return r;
}

float cylinder(vec3 p, vec3 c, float l){
	return max(length(p) - l, length(p.xz-c.xy)-c.z);
}
	    
float tube( vec3 p, vec3 c )
{
  return length(p.xz-c.xy)-c.z;
}

float cone( vec3 p, vec2 c )
{
    float q = length(p.xy);
    return dot(c,vec2(q,p.z));
}

float sphere(vec3 p,  float radius){
	return length(p) - radius;
}

float cube(vec3 v, vec3 size, vec3 position) {
	vec3 distance = abs(v + position) - size;
	vec3 distance_clamped = max(distance, 0.0);
	return length(distance_clamped);
}

float torus(vec3 p, vec2 t) {
    vec2 q = vec2(length(p.xz) - t.x, p.y);
    return length(q) - t.y;
}

float plane(vec3 p, vec4 n) { // n must be normalized
    return dot(p, n.xyz) + n.w;
}


float blend(float d1, float d2) {
    float dd = cos((d1 - d2) * PI);
    return mix(d1, d2, dd);
}

float intersect(vec3 ro, vec3 rd){
	
	float dist = 0.0;
	vec3 rp = ro;
	float dt;
	for(int i = 0; i < 64; ++i){
		dist = map(rp);
		if(dist <= 0.000001) break;
		if(dist >= 16.0) break;
		dt += dist*.75;
		rp = ro + rd * dt * .999995;
	}
	if(dt < 16.0) return dt;
	return -1.0;
}

vec3 norm(vec3 p){
	vec3 n;
	n.x = map(p + vec3(0.00001, 0.0,0.0))    - map(p- vec3(0.00001, 0.0,0.0));
	n.y = map(p + vec3(0.0, 0.00001,0.0))    - map(p- vec3(0.0, 0.00001,0.0));
	n.z = map(p + vec3(0.0, 0.0,0.00001))    - map(p- vec3(0.0, 0.0,0.00001));
	return normalize(n);
}

vec3 rotate(vec3 p, vec3 v, float a){
	a = radians(a);
	v = normalize(v);
	float cosa = cos(a);
	float sina = sin(a);
	float omc = 1.0 - cosa; // one minus cos(a)
	mat3 m = mat3(
		v.x*v.x*omc + cosa,     v.y*v.x*omc - v.z*sina, v.z*v.x*omc + v.y*sina,
		v.x*v.y*omc + v.z*sina, v.y*v.y*omc + cosa    , v.z*v.y*omc - v.x*sina,
		v.x*v.z*omc - v.y*sina, v.y*v.z*omc + v.x*sina, v.z*v.z*omc + cosa
	);
	return p*m; 
					 
}

vec3 mrotate(vec3 p){
	p = rotate(p, vec3(0.,1.,0.), TAU * degrees(mouse.x));
	p = rotate(p, vec3(0.,0.,1.), TAU * degrees(mouse.y));
	
	return p; 				 
}

float hash(vec2 co)
{
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p, float s){
	return fract(956.9*cos(429.9*dot(vec3(p,s),vec3(9.7,7.5,11.3))));
}
 
float mix2(float a2, float b2, float t2)
{
	return mix(a2,b2,t2*t2*(3.-2.*t2)); 
}
	
float fractnoise(vec2 p, float s, float c){
	float sum = .0;
	for(float i=0. ;i<3.; i+=1.){
        
		vec2 pi = vec2(pow(2.,i+c));
		vec2 posPi = p*pi;
		vec2 fp = fract(posPi);
		vec2 ip = floor(posPi);
	
		float n0 = noise(ip, s);
		float n1 = noise(ip+vec2(1.,.0), s);
		float n3 = noise(ip+vec2(.0,1.), s);
		float n4 = noise(ip+vec2(1.,1.), s);
		
		float m0 = mix2(n0,n1, fp.x);	
		float m1 = mix2(n3,n4, fp.x);
		float m3 = mix2(m0, m1, fp.y);
		
        	sum +=abs(2.0*pow(.5,i+c)*m3);
	}
	
	return sum*(2.2-c);
}

vec3 ray(vec2 pixel, vec3 pos, vec3 target){
	vec3 front = normalize(target - pos);
	vec3 left = normalize(cross(vec3(0.0, 1.0, 0.0), front));
	vec3 up = normalize(cross(front, left));
	return normalize(front*1.5 + left*pixel.x + up*pixel.y); // rect vector
}