// strange clouds
// - little fluffy clouds - @simesgreen
// - added volumetric light dispersion in gas simulation (slightly fake). psonice
// - swapped in more basic noise and tweaked a few places. fullreset

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
uniform float zoom;

uniform vec2 surfaceSize;
uniform vec2 surfacePosition;

const float _StepSize = 0.125; 
const float _Density = 0.125;

const float _SphereRadius = 1.8;
const float _NoiseFreq = 0.75;
const float _NoiseAmp = 2.75;
const vec3  _NoiseAnim = vec3(0., 0., 0.);

const vec3  _Speed          = vec3(1.3,0,-0.5);
const float _GlowExtent = 2.0;

//////////////////////////////////////////////////////////////
// http://www.gamedev.net/topic/502913-fast-computed-noise/
// replaced costly cos with z^2. fullreset
vec4 random4 (const vec4 x) {
    vec4 z = mod(mod(x, vec4(5612.0)), vec4(3.1415927 * 2.0));
    return fract ((z*z) * vec4(56812.5453));
}

const float A = 1.0;
const float B = 57.0;
const float C = 113.0;
const vec3 ABC = vec3(A, B, C);
const vec4 A3 = vec4(0, B, C, C+B);
const vec4 A4 = vec4(A, A+B, C+A, C+A+B);

float cnoise4 (const in vec3 xx) {
    vec3 x = xx; // mod(xx + 32768.0, 65536.0); // ignore edge issue
    vec3 fx = fract(x);
    vec3 ix = x-fx;
    vec3 wx = fx*fx*(3.0-2.0*fx);
    float nn = dot(ix, ABC);

    vec4 N1 = nn + A3;
    vec4 N2 = nn + A4;
    vec4 R1 = random4(N1);
    vec4 R2 = random4(N2);
    vec4 R = mix(R1, R2, wx.x);
    float re = mix(mix(R.x, R.y, wx.y), mix(R.z, R.w, wx.y), wx.z);

    return 1.0 - 2.0 * re;
}
// http://www.gamedev.net/topic/502913-fast-computed-noise/
//////////////////////////////////////////////////////////////

#define snoise(x) cnoise4(x)

float fbm(vec3 p) {
    float f;
    f = 0.5000*snoise( p ); p = p*2.02;
    f += 0.2500*snoise( p ); p = p*2.03;
    f += 0.1250*snoise( p ); p = p*2.01;
    f += 0.0625*snoise( p ); 
  return f;
}

// returns signed distance to surface
float distanceFunc (vec3 p) {	
	p += _Speed*time;	

	// repeat
	vec3 q = p;
	q.xz = mod(q.xz - vec2(2.5), 5.0) - vec2(2.5) ;
        q.y *= 2.0;

	float d = length(q) - _SphereRadius;	// distance to sphere
	d += fbm(p*_NoiseFreq + _NoiseAnim*time) * _NoiseAmp;
	return d;
}

// map distance to color
vec4 shade(float d) {
	float phase = abs(pow(sin(1.5*time),2.0));
	return mix(vec4(0.8, 0.8, 0.8, _Density), vec4(1., 0.6, 0, 0), smoothstep(0.25, 1.0+_GlowExtent*phase, d));
}

// procedural volume
// maps position to color
vec4 volumeFunc(vec3 p) {
	float d = distanceFunc(p);
	return shade(d);
}

// ray march volume from front to back, returning color
vec4 rayMarch(vec3 rayOrigin, vec3 step, out vec3 pos) {
    vec4 sum = vec4(0.1, 0.2, 0.25, 0);
    pos = rayOrigin;
    vec4 col;
#define RAY1 col = volumeFunc(pos); col.rgb *= (pos.y+.5); col.rgb *= col.a; sum = sum + col*(1.0 - sum.a); pos += step;
#define RAY4 RAY1 RAY1 RAY1 RAY1
    RAY4 RAY4 RAY4 RAY4
    return sum;
}

void main(void) {
    vec2 q = gl_FragCoord.xy / resolution.xy;
    vec2 p = -1.0 + 2.0 * q;
    p.x *= resolution.x/resolution.y;
	
    float rotx = mouse.y*5.0;
    float roty = - mouse.x*5.0;

    float zoom = 5.0*surfaceSize.y;

    // camera
    vec3 ro = zoom*normalize(vec3(cos(roty), cos(rotx), sin(roty)));
    vec3 ww = normalize(vec3(0.0,0.0,0.0) - ro);
    vec3 uu = normalize(cross( vec3(0.0,1.0,0.0), ww ));
    vec3 vv = normalize(cross(ww,uu));
    vec3 rd = normalize( p.x*uu + p.y*vv + 1.5*ww );

    ro += rd*4.0;
	
    // volume render
    vec3 hitPos;
    vec4 col = rayMarch(ro, rd*_StepSize, hitPos);
    gl_FragColor = col;
}