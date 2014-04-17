// miles@resatiate.com
// based on http://glsl.heroku.com/e#6079.4

#ifdef GL_ES
precision mediump float;
#endif

// map settings
#define BAILOUT 4.
#define MAX_ITER 10
#define VIEWPORT_MAX 0.5
#define VIEWPORT_MIN 0.0000428	
#define VIEWPORT_SCALE 0.003
#define VIEWPORT_OFFSET 0.7
#define VIEWPORT_MOD .3
#define MAP_MULTIPLIER 1.05
// camera settings
#define FOCUS .9
#define ZOOM 0.466674159
#define SPEED .01
#define MAX_MARCH 250
#define MAX_DISTANCE 200.0
#define MIN_DISTANCE 0.1
// color settings
#define COLOR_SCALE 0.393141
#define COLOR_MOD_SCALE 0.9999
#define COLOR_MOD_RED 0.0035
#define COLOR_MOD_GREEN 0.00255
#define COLOR_MOD_BLUE 0.006142
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

vec2 f(vec2 z) {
	vec2 z2 = vec2(z.x*z.x-z.y*z.y,2.*z.x*z.y);
	vec2 z3 = vec2(z2.x*z.x-z2.y*z.y,z2.x*z.y+z2.y*z.x);
	vec2 z4 = vec2(z3.x*z.x-z3.y*z.y,z3.x*z.y+z3.y*z.x);
	return z4-vec2(1,0);
}

vec2 fd(vec2 z) {
	vec2 z2 = vec2(z.x*z.x-z.y*z.y,2.*z.x*z.y);
	vec2 z3 = vec2(z2.x*z.x-z2.y*z.y,z2.x*z.y+z2.y*z.x);
	return 4.*z3;
}

vec2 fdd(vec2 z) {
	vec2 z2 = vec2(z.x*z.x-z.y*z.y,2.*z.x*z.y);
	return 12.*z2;
}

vec3 getLambdaColor (vec2 z, vec2 r) {
    for (int i=0; i < MAX_ITER; i++) {
	vec2 v = f(z);
	vec2 vd = fd(z);
	vec2 vdd = fdd(z);
	    
	vec2 b = 2.*vec2(v.x*vd.x-v.y*vd.y,v.x*vd.y+v.y*vd.x);
	vec2 a = 2.*vec2(vd.x*vd.x-vd.y*vd.y,2.*vd.x*vd.y)-vec2(v.x*vdd.x-v.y*vdd.y,v.x*vdd.y+v.y*vdd.x);

	vec2 d = vec2(b.x*a.x+b.y*a.y,b.y*a.x-b.x*a.y)/dot(a,a);
	d = vec2(d.x*r.x-d.y*r.y,d.x*r.y+d.y*r.x);
	z -= d;

    }
    vec2 s = z;
    return vec3(cos(s.x),cos(s.x+2.1),cos(s.x-2.1))*(sin(s.y)+1.)*.25+.5;
}

vec3 milesmap(vec3 ray)
{
    float Power= 2.5;
	
    vec3 p = ray;
    vec3 c = p;
	
    float len=0.0;
    float d=1.0;
    float theta, phi = 0.;
    for(int n=0; n<=MAX_ITER; ++n)
    {
        len = length(p);
        if(len>BAILOUT) break;
        theta = acos(p.z/len);
        phi = atan(p.y, p.x);
        d = pow(len,Power-1.0)*Power*d+1.0;
        float zr = pow(len,Power);
        theta = theta*Power;
        phi = phi*Power;
        p = (vec3(sin(theta)*cos(theta), sin(phi)*sin(theta), cos(theta))*zr)+c;
    }
    
    return getLambdaColor(p.xx, p.yy);// * (MAP_MULTIPLIER*log(len)*len/d);//vec3(MAP_MULTIPLIER*log(len)*len/d,theta*log(len)*len/d,phi*log(len)*len/d);
}


void main( void )
{
    vec2 pos = surfacePosition;//(gl_FragCoord.xy*0.6 - resolution.xy) / resolution.y;
    float t = time * SPEED;
    vec3 camPos = vec3(sin(t), cos(t), ZOOM);
    vec3 camTarget = vec3(0., 0., 0.);//vec3(0.0, 0.0, 0.0);
    vec3 camDir = normalize(camTarget-camPos);
    vec3 camUp  = normalize(vec3(0.0, 1.0, 0.0));
    vec3 camSide = cross(camDir, camUp);

    vec3 rayDir = normalize(camSide*pos.x + camUp*pos.y + camDir*FOCUS);
    vec3 ray = camPos;
    float total_iter = 0.0;
    vec3 d = vec3(0.,0.,0.), total_d = vec3(0.,0.,0.);

    for(int i=0; i<MAX_MARCH; ++i) {
        d = milesmap(ray);
        total_d += d;
        ray += rayDir * d;
        total_iter += 1.0;
        if(d.x * d.y / d.z * d.z<MIN_DISTANCE) { break; }
        if(total_d.x * d.y>MAX_DISTANCE) { total_d.x=MAX_DISTANCE; break; }
    }

    vec3 c = (total_d) * COLOR_SCALE;

    vec4 result = vec4( 1.0-c - vec3(COLOR_MOD_RED, COLOR_MOD_GREEN, COLOR_MOD_BLUE)*total_iter*COLOR_MOD_SCALE, 1.0 );
    gl_FragColor = result;
}
