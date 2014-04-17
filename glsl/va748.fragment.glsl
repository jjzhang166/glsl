#ifdef GL_ES
precision mediump float;
#endif

// Set to 1x for better results.

// Modutropolis by @acaudwell - http://glsl.heroku.com/e#327.0
// Batman Curve by Caiwan^IR  - http://glsl.heroku.com/e#732.3
// The obvious mashup by someone else...  http://glsl.heroku.com/e#748

// TODO: Insert joke about world's first cloud-based push notification.

uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

// Batman Curve
// http://www.wolframalpha.com/input/?i=batman+curve
// by Caiwan^IR

float batman( vec2 p ) {
  	float ax = abs(p.x);
  
	float a = ((p.x*p.x)/49.0) + ((p.y*p.y)/9.0) - 1.0;
  	//float b = ax-4.0;
  	float c = -2.461955;
  	//float d = ax-3.0;
  	float e = (0.5*abs(p.x))+sqrt(1.0-pow((abs(abs(p.x)-2.0)-1.0),2.0))-(1.0/112.0)*10.23369*(p.x*p.x)-p.y-3.0;
  	float f = (3.0/4.0);
  	float g = -8.0*ax-p.y+9.0;
  	float h = 3.0*ax-p.y+f;
  	float i = (9.0/4.0)-p.y;
      	float j = -.5*ax-1.3553*sqrt(4.0-pow((ax-1.0),2.0))-p.y+2.71052+(3.0/2.0);
  	if (
          	(a <= 0.0) && (
          	(ax >= 4.0) && ((c <= p.y) && (p.y <= 4.0)) ||
          	(ax > 3.0)  && (p.y >= 0.0) ||
          	((-3.0 <= p.y) && (p.y <= 0.0)) &&
          	((-4.0 <= p.x) && (p.x <= 4.0)) &&
          	(e <= 0.0) )||
          	(p.y>0.0) && ((f <= ax) && (ax <= 1.0)) &&
          	(g >= 0.0) || 
          	((.5 <= ax) && (ax <= f)) &&
          	(h >= 0.0) && (p.y > 0.0) ||
          	(ax <= 0.5) && (p.y > 0.0) && 
          	(i >= 0.0) || 
          	(ax >= 1.0) && (p.y > 0.0) &&
          	(j >= 0.0)
          	
           ) {
  		return 1.0;
        }
	
	return 0.0;
}

float signal( vec2 p ) {
	p.x *= 0.5;
	if (length(p) < 4.0) {
		return 1.0;
	}
	p.x -= 1.0;
	if ((p.y < -1.0) && (abs(p.y + p.x * 2.3) < (7.0 - 0.7 * p.x))) {
        	return clamp(1.2 + 0.08 * p.y - 0.05 * p.x, 0.0, 1.0);
	}
	return 0.0;
}

// --------------------------
// Modutropolis by @acaudwell
// thealphablenders.com

#define MAX_RAY_STEPS 250

float aspect_ratio = resolution.y / resolution.x;
float ray_scale    = (1.0 / max(resolution.x, resolution.y)) * 0.5;
float fov          = tan ( 75.0 * 0.017453292 * 0.5 );

float building(vec3 p) {

    float box = 3.0;

    vec3 q = mod(p, box)-box*0.5;

    vec3 b = vec3(box*0.5, 1.5, 1.5);
    float r = fract(p.y)*0.1;

    float bounds = length(max(abs(p)-vec3(box*2.0, box*4.0, box), 0.0));
    float scafold= max( length(max(abs(q)-b, 0.0)), length(max(abs(q)-b, -r))-r);

    return max(bounds , scafold);
}

float city(vec3 p) {

    float box = 20.0;

    float hv = -mod(ceil(p.x/20.0), 3.0)*2.0;

    float horizon = 400.0;

    vec3 bb = vec3(horizon , 47.05 + hv, horizon );

    vec3 q = mod(p, box)-box*0.5;

    float b = building(p);

    float bounds    =  length(max(abs(p)-bb, 0.0));
    float buildings =  building(q);

    return max( bounds, buildings );
}

void main( void ) {

    vec2 tx = ((gl_FragCoord.xy / resolution)-0.5) * 2.0;

    float a  = (0.5 - mouse.x) * 3.142;
    float sa = sin(a)*1.1;
    float ca = cos(a);

    vec3 dir = vec3( tx.x * fov , tx.y * fov * aspect_ratio + mouse.y - 0.5, 1.0 );
 
    //dir.xy   = vec2( dir.x * ca - dir.y * sa, dir.x * sa + dir.y * ca);
    dir.xz   = vec2( dir.x * ca - dir.z * sa, dir.x * sa + dir.z * ca);

    dir = normalize(dir);

    vec3 cam = vec3(0.0, 45.0, 0.0);
    //cam.xz   = vec2( cam.x * ca - cam.z * sa, cam.x * sa + cam.z * ca);

    vec3 ray = cam;

    float l  = 0.0;
    float d  = 0.0;
    float e  = 0.00001;
    float it = 0.0;

    for(int i=0;i<MAX_RAY_STEPS;i++) {
        d = city(ray);

        ray += d * dir;
        l += d;

        if(d<e) break;

        e  = ray_scale * l;
        it++;
    }

    float f = 0.9-(it/float(MAX_RAY_STEPS));

    vec3 bg = vec3(pow(length(tx*0.5),3.5));

    float lights = max(0.0, pow(max(abs(tx.y), 1.0), 1.0))*0.5;
    float sky    = max(0.0, pow(max(tx.y+min(300.0,l)*0.01, 0.0), 0.9))*0.9;

    float skyMask = 1.0 - (smoothstep(0.0, 0.1, f));

    vec2 batPos = dir.xy * 20.0 + vec2(7.0, -10.0);
    float batmanF = batman(batPos);
    float signalF = signal(batPos) * skyMask;

    vec3 lc = vec3(lights*1.1, 1.2*lights, lights*1.5)*0.67;
    vec3 sc = vec3(sky*0.1, sky*0.20, sky);

    vec3 c = vec3(1.0-f)*max(lc*0.7,sc*0.2);
    c = (c * (1.0 - signalF)) + (signalF * vec3(1.0, 0.9, 0.4) * (1.0 - batmanF));

    gl_FragColor = vec4(c, 1.0);
}