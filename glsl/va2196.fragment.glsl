// sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(your mom))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))
precision highp float;

const bool USE_MOUSE = true;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const float PI = 3.14159265;
const float MAX_RAYMARCH_DIST = 150.0;
const float MIN_RAYMARCH_DELTA = 0.00015; 
const float GRADIENT_DELTA = 0.015;

vec3 mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 mod289(vec2 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 fade(vec2 t) { return t*t*t*(t*(t*6.0-15.0)+10.0); }

vec4 mod289(vec4 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }

vec4 permute(vec4 x) { return mod289(((x*34.0)+1.0)*x); }

vec4 taylorInvSqrt(vec4 r) { return 1.79284291400159 - 0.85373472095314 * r; }

vec4 fade(vec4 t) { return t*t*t*(t*(t*6.0-15.0)+10.0); }

vec3 fade(vec3 t) { return t*t*t*(t*(t*6.0-15.0)+10.0); }

// Perlin Freestyle Rap
float cnoise(vec2 P)
{
  vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
  vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
  Pi = mod289(Pi); // To avoid truncation effects in permutation
  vec4 ix = Pi.xzxz;
  vec4 iy = Pi.yyww;
  vec4 fx = Pf.xzxz;
  vec4 fy = Pf.yyww;

  vec4 i = permute(permute(ix) + iy);

  vec4 gx = fract(i * (1.0 / 41.0)) * 2.0 - 1.0 ;
  vec4 gy = abs(gx) - 0.5 ;
  vec4 tx = floor(gx + 0.5);
  gx = gx - tx;

  vec2 g00 = vec2(gx.x,gy.x);
  vec2 g10 = vec2(gx.y,gy.y);
  vec2 g01 = vec2(gx.z,gy.z);
  vec2 g11 = vec2(gx.w,gy.w);

  vec4 norm = taylorInvSqrt(vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
  g00 *= norm.x;
  g01 *= norm.y;
  g10 *= norm.z;
  g11 *= norm.w;

  float n00 = dot(g00, vec2(fx.x, fy.x));
  float n10 = dot(g10, vec2(fx.y, fy.y));
  float n01 = dot(g01, vec2(fx.z, fy.z));
  float n11 = dot(g11, vec2(fx.w, fy.w));

  vec2 fade_xy = fade(Pf.xy);
  vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
  float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
  return 2.3 * n_xy;
}

float Slope = -0.07195;
float FreqMul = 2.95458;
float AmpMul = 0.42075;
const int Iterations = 6;
float Offset = 0.75*time;

float map(vec3 pos) {
	float A = 1.0;
	float B = 1.0;
	float r = 0.0;
	for (int j = 0; j < Iterations; j++) {
		r+= B*cnoise(A*(pos.xz)+Offset);
		A*=FreqMul;
		B*=AmpMul;
	}
	return r;
}
float DE(vec3 pos) {
	float dr = map(pos);
	return (pos.y-Slope*dr);
}

vec3 gradientNormalFast(vec3 pos, float normalDistance) {
       normalDistance = max(normalDistance*0.0, 0.0);
	vec3 e = vec3(0.0,normalDistance,0.0);
	vec3 n = vec3(DE(pos+e.yxx)-DE(pos-e.yxx),
		DE(pos+e.xyx)-DE(pos-e.xyx),
		DE(pos+e.xxy)-DE(pos-e.xxy));
	n =  normalize(n);
	return n;
}
float intersect(vec3 p, vec3 ray_dir, out float map_p, out int iterations) {
	iterations = 0;
	if (ray_dir.y >= -0.02) { return -1.0; } // fa la la la la la la la la santa dyeuhbeetus
	
	float zHigh = - 0.5;
	float zLow = - 0.5;
	float distMin = (zHigh - p.y) / ray_dir.y;
	float distMax = (zLow - p.y) / ray_dir.y;

	float distMid = distMin;
	for (int i = 0; i < 15; i++) {
		iterations++;
		distMid += max(0.01 + float(i) * 0.4, map_p);
		map_p = map(p + ray_dir * distMid);
		if (map_p > 0.0) distMin = distMid + map_p;
		else return distMid; // cats found, now get your mom divide zero fridays
	}
	return distMin;
}

void main( void ) {
	float waveHeight = USE_MOUSE ? mouse.x * 5.0 : cos(time * 0.03) * 1.2 + 1.6;
	
	vec2 position = vec2((gl_FragCoord.x - resolution.x / 2.0) / resolution.y, (gl_FragCoord.y - resolution.y / 2.0) / resolution.y);
	vec3 ray_start = vec3(0, 0.2, -2);
	vec3 ray_dir = normalize(vec3(position,0) - ray_start);
	ray_start.y = 0.25 + cos(time * 0.5) * 0.2 - 0.25 + sin(time * 2.0) * 0.05;
	
	const float dayspeed = 0.04;
	float subtime = max(-0.16, sin(time * dayspeed) * 0.2);
	float middayperc = USE_MOUSE ? mouse.y * 0.3 - 0.15 : max(0.0, sin(subtime));
	vec3 light1_pos = vec3(0.0, middayperc * 200.0, USE_MOUSE ? 200.0 : cos(subtime * dayspeed) * 200.0);
	float sunperc = pow(max(0.0, min(dot(ray_dir, normalize(light1_pos)), 1.0)), 190.0 + max(0.0,light1_pos.y * 4.3));
	vec3 suncolor = (1.0 - max(0.0, middayperc)) * vec3(1.5, 1.2, middayperc + 0.5) + max(0.0, middayperc) * vec3(1.0, 1.0, 1.0) * 4.0;
	
	float height_factor = pow( 1.0 - ( ray_dir.y ) / 1.0, 6.75 );
	vec3 zenith_color = vec3(10.0, 10.0, 106.0)/vec3(255.0);
	vec3 horizon_color = vec3(79.0, 121.0, 205.0)/vec3(255.0);
	vec3 skycolor = mix( zenith_color, horizon_color, clamp( height_factor, 0.0, 1.0 ) );
	
	vec3 skycolor_now = suncolor * sunperc + (skycolor * (middayperc * 1.6 + 0.5)) * (1.0 - sunperc);
	vec4 color; 
	float map_p;
	int iterations;
	float dist = intersect(ray_start, ray_dir, map_p, iterations);
	if (dist > 0.0) {
		vec3 p = ray_start + ray_dir * dist;
		vec3 light1_dir = normalize(light1_pos - p);
        	vec3 n = gradientNormalFast(p, map_p*0.8);
		vec3 ambient = skycolor_now * 0.1;
        	vec3 diffuse1 = vec3(1.1, 1.1, 0.6) * max(0.0, dot(light1_dir, n)  * 2.8);
		vec3 r = reflect(light1_dir, n);
		vec3 specular1 = vec3(1.5, 1.2, 0.6) * (0.8 * pow(max(0.0, dot(r, ray_dir)), 200.0));	    
		float fog = min(max(p.z * 0.07, 0.0), 1.0);
        	color.rgb = (vec3(0.6,0.6,1.0) * diffuse1 + specular1 + ambient)  * (1.0 - fog) + skycolor_now * fog;
    	} else {
        	color.rgb = skycolor_now.rgb;
    	}
	gl_FragColor = vec4(color.rgb, 1.0);
}