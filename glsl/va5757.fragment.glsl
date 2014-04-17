#ifdef GL_ES
precision mediump float;
#endif

// Posted by Trisomie21

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// from http://glsl.heroku.com/e#5248.0
#define BLADES 3.0
#define BIAS 0.1
#define SHARPNESS 2.0
vec3 star(vec2 position) {
	float blade = clamp(pow(sin(atan(position.y,position.x )*BLADES)+BIAS, SHARPNESS), 0.0, 1.0);
	vec3 color = mix(vec3(-0.34, -0.5, -1.0), vec3(0.0, -0.5, -1.0), (position.y + 1.0) * 0.25);
	color += (vec3(0.95, 0.65, 0.30) * 1.0 / distance(vec2(0.0), position) * 0.075);
	color += vec3(0.95, 0.45, 0.30) * min(1.0, blade *0.7) * (1.0 / distance(vec2(0.0, 0.0), position)*0.075);
	return vec3(0);

}


// Tweaked from http://glsl.heroku.com/e#4982.0
float hash( float n ) { return fract(sin(n)*43758.5453); }

float noise( in vec3 x )
{
	vec3 p = floor(x);
	vec3 f = fract(x);
    	f = f*f*(3.0-2.0*f);
    	float n = p.x + p.y*57.0 + p.z * 43.0;
    	float res1 = mix(mix(hash(n+0.0), hash(n+1.0),f.x), mix(hash(n+57.0), hash(n+57.0+1.0),f.x),f.y);
    	float res2 = mix(mix(hash(n+43.0), hash(n+43.0+1.0),f.x), mix(hash(n+43.0+57.0), hash(n+43.0+57.0+1.0),f.x),f.y);
	float res = mix(res1, res2, f.z);
    	return res;
}

float rand(vec2 co){ return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453); }
float rand3(vec3 co){ return fract(sin(dot(co.xyz ,vec3(12.9898,78.233,53.251))) * 43758.5453); }

float cloud(vec3 p) {
	float f = 0.0;
    	f += 0.50000*noise(p*1.0*10.0); 
    	f += 0.25000*noise(p*2.0*10.0); 
    	f += 0.12500*noise(p*4.0*10.0); 
    	f += 0.06250*noise(p*8.0*10.0);	
	f *= f;
	return f;
}

const float LAYERS	= 4.0;
const float SPEED	= 0.005;
const float SCALE	= 30.0;
const float DENSITY	= 1.5;
const float BRIGHTNESS	= 10.0;
       vec2 ORIGIN	= resolution.xy*.5;

void main( void ) {
	
	vec2   pos = gl_FragCoord.xy - ORIGIN;
	float dist = length(pos) / resolution.y;
	vec2 coord = vec2(pow(dist, 0.1), atan(pos.x, pos.y) / (3.1415926*2.0));
	pos = vec2(gl_FragCoord.x + (resolution.y - resolution.x)/2.0, gl_FragCoord.y) / resolution.yy * 2.0 - 1.0;
	vec3 dir = normalize(vec3(mouse, 1.0)), up = vec3(0.0, 1.0, 0.0);
	vec3 sdir = normalize(pos.x * cross(up, dir) + pos.y * up + 1.0 * dir);
	
	// Nebulous cloud
	vec3 color = cloud(sdir) * vec3(0.65, 0.45, 1.0) * 0.6;
	
//	color += clamp(cloud(sdir*15.0)-0.5, 0.0, 1.0)*10.0;
	float dstar = min(distance(mod(sdir, vec3(0.057, 0.063, 0.073)), vec3(0.021, 0.027, 0.017)), distance(mod(sdir, vec3(0.047, 0.055, 0.081)), vec3(0.013, 0.017, 0.015)));
	color += 1.0-clamp(dstar / 0.003 ,0.0,1.0);//? 1.0 : 0.0;
	
	// Background stars
	float a = pow((1.0-dist),20.0);
	float t = time*-.05;
	float r = sdir.x;// - (t*SPEED);
	float c = fract(a+sdir.y + 0.0*.543);
	vec2  p = vec2(r, c*.5)*4000.0;
	vec2 uv = fract(p)*2.0-1.0;
	float m = clamp((rand(floor(p))-.9)*BRIGHTNESS, 0.0, 1.0);
	color +=  clamp((1.0-length(uv*2.0))*m*dist, 0.0, 1.0);
	
	gl_FragColor = vec4(color, 0.2);
}