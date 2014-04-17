
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159
#define WITH_ORBIT_TRAP

vec3 cubeColor(vec3 p, vec3 pObj, vec3 size) ;
vec3 cubeColorWrap(vec3 p, vec3 pObj, vec3 size) ;

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
float acosAngle(vec2 v) {
	float x = v.x;
	float y = v.y;
	if (x == 0.0 && y == 0.0)
		return 0.0;
	float a = acos(x / sqrt(x * x + y * y)); 
	if (y < 0.0)
		a = 2.0 * PI - a;
	return 2.0 * PI - a;
}
vec3 getVectorColorRGBCircular(float angle, float intensity) {
	float r = ((sin(angle + PI / 2.0) + 0.5) * intensity);
	float g = ((sin(angle + PI / 2.0 - 1.0 / 3.0 * 2.0 * PI) + 0.5) * intensity);
	float b = ((sin(angle + PI / 2.0 - 2.0 / 3.0 * 2.0 * PI) + 0.5) * intensity);
	return vec3(r,g,b);
}
vec3 getVectorColorRGBCircular(vec2 p, vec2 cc, float intensity) {
	float angle = acosAngle(p-cc);
	vec3 col = getVectorColorRGBCircular(angle, intensity);
	return col;
}

float map(vec3 p, out vec3 pComplex, out vec3 colOrbitTrap)
{
	colOrbitTrap = vec3(0);
    const int MAX_ITER = 20;
    const float BAILOUT=4.0;
    float Power=8.0;

    vec3 v = p;
    vec3 c = v;
	vec3 colOTSum;
    float r=0.0;
    float d=1.0;
    for(int n=0; n<=MAX_ITER; ++n)
    {
        r = length(v);
        if(r>BAILOUT) break;

        float theta = acos(v.z/r);
        float phi = atan(v.y, v.x);
        d = pow(r,Power-1.0)*Power*d+1.0;

        float zr = pow(r,Power);
        theta = theta*Power;
        phi = phi*Power;
        v = (vec3(sin(theta)*cos(phi), sin(phi)*sin(theta), cos(theta))*zr)+c;
#ifdef WITH_ORBIT_TRAP
#define OT_SIZE 1.0
	colOTSum += (sin(v*PI))*0.25;
	//colOTSum += hsv2rgb(vec3(length(v),1.0,1.0))*0.2; 
	//colOTSum += cubeColor(v, vec3(0.0), vec3(+OT_SIZE*PI))/2.0; 
	//colOTSum += cubeColor(v, vec3(0.0), vec3(-OT_SIZE*PI))/2.0;
	//colOrbitTrap += cubeColor(v, vec3(-0.0*PI), vec3(1.0*PI+time));
	//if (all(greaterThan(colOrbitTrap, vec3(0))) && all(lessThanEqual(colOrbitTrap, vec3(1)))) //excludes black meaning NO COLOR
	//    break; //inside orbit trap //hit bitmap/model
#endif
    }
	pComplex = v;
#ifdef WITH_ORBIT_TRAP
	colOrbitTrap = colOTSum+0.25;
#endif
    return 0.5*log(r)*r/d;
}
float distManhatten(vec3 v) {
	return abs(v.x) + abs(v.y) + abs(v.z);
}
float distManhattenMin(vec3 v) {
	return min(min(abs(v.x) , abs(v.y)) , abs(v.z));
}
float cube(vec3 p, vec3 pObj, vec3 size) {
	vec3 p2 = pObj+size;
	vec3 pmin = min(pObj, p2);
	vec3 pmax = max(pObj, p2);
	if (p.x < pmin.x || p.y < pmin.y || p.z < pmin.z)
		return -distManhattenMin(p-pmin);
	if (p.x > pmax.x || p.y > pmax.y || p.z > pmax.z)
		return -distManhattenMin(pmax-p);
	return min(distManhattenMin(p-pmin), distManhattenMin(p-pmax));
}
//unit cube for rgb colors
vec3 cubeColor(vec3 p, vec3 pObj, vec3 size) {
	if (size == 0.0)
		size = vec3(1);
	//return getVectorColorRGBCircular(p.xz,vec2(0),0.1);
	vec3 p2 = pObj+size;
	vec3 pmin = min(pObj, p2);
	vec3 pmax = max(pObj, p2);
	if (p.x < pmin.x || p.y < pmin.y || p.z < pmin.z)
		return vec3(0);
	if (p.x > pmax.x || p.y > pmax.y || p.z > pmax.z)
		return vec3(0);
	return ((p-pmin)/size);
}
vec3 cubeColorWrap(vec3 p, vec3 pObj, vec3 size) {
	if (size == 0.0)
		size = vec3(1);
	return fract((p-pObj)/size);
}
float sphere(vec3 p, vec3 pObj, float radius) {
	return length(p-pObj) - radius;
}

void main( void )
{
    vec2 pos = (gl_FragCoord.xy*2.1 - resolution.xy) / resolution.y;
    vec3 camPos = vec3(cos(time*0.2), sin(time*0.2), 1.5);
    vec3 camTarget = vec3(0.0, 0.0, 0.0);

    vec3 camDir = normalize(camTarget-camPos);
    vec3 camUp  = normalize(vec3(0.0, 1.0, 0.0));
    vec3 camSide = cross(camDir, camUp);
    float focus = 1.8;

    vec3 rayDir = normalize(camSide*pos.x + camUp*pos.y + camDir*focus);
    vec3 ray = camPos;
    float m = 0.0;
    float d = 0.0, total_d = 0.0;
    const int MAX_MARCH = 50;
    const float MAX_DISTANCE = 1000.0;
	vec3 pComplexEnd;
	vec3 colOrbitTrap;
	float distMin = 1e10;
    for(int i=0; i<MAX_MARCH; ++i) {
        d = map(ray,pComplexEnd,colOrbitTrap);
	//d -= cube(ray, vec3(-0.5,-0.5,-0.5), vec3(1.0));
	//d -= sphere(ray, vec3(0), 1.0);
	distMin = min(distMin, length(pComplexEnd-vec3(0)) );
        total_d += d;
        ray += rayDir * d;
        m += 1.0;
        if(d<0.001) { break; }
        if(total_d>MAX_DISTANCE) { total_d=MAX_DISTANCE; break; }
    }
	vec3 color;
    	float c = (total_d)*0.0001;
    	//color += 1.0-vec3(c, c, c) - vec3(0.025, 0.025, 0.02)*m*0.8;
	//color += vec3(0.025, 0.025, 0.02)*m*0.8;
#ifndef WITH_ORBIT_TRAP
	color += vec3(1.0-m/float(MAX_MARCH));
#endif
	//color += cubeColor(pComplexEnd, vec3(-1000.0), vec3(2000.0));
	//color += cubeColor(pComplexEnd, vec3(-7.0*PI), vec3(14.0*PI));
	//color += cubeColorWrap(pComplexEnd, vec3(-1000.0), vec3(2000.0));
	//color += cubeColorWrap(pComplexEnd, vec3(-7.0*PI), vec3(14.0*PI));
	//color += vec3(distMin*0.1);
#ifdef WITH_ORBIT_TRAP
	color += colOrbitTrap;
#endif
    	gl_FragColor.xyz = color;
}
