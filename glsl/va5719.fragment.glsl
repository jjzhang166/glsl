#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

// Posted by Trisomie21

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// from http://glsl.heroku.com/e#5248.0
#define BLADES 6.0
#define BIAS 0.1
#define SHARPNESS 3.0
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
const float SCALE	= 80.0;
const float DENSITY	= 1.5;
const float BRIGHTNESS	= 10.0;
       vec2 ORIGIN	= resolution.xy*.5;

struct stroke { vec2 pos; float rnd; vec3 rot; vec2 scale; };

const int num = 2;
	
stroke ss[num];	

void main( void ) {
	
	vec2   pos = gl_FragCoord.xy - ORIGIN;
	float dist = length(pos) / resolution.y;
	vec2 coord = vec2(pow(dist, 0.1), atan(pos.x, pos.y) / (3.1415926*2.0));
	pos = vec2(gl_FragCoord.x + (resolution.y - resolution.x)/2.0, gl_FragCoord.y) / resolution.yy * 2.0 - 1.0;
	pos /= 1.2;
	vec3 dir = normalize(vec3(mouse.x,0.0, 1.0)), up = vec3(0.0, 1.0, 0.0);
	vec3 sdir = normalize(pos.x * cross(up, dir) + pos.y * up + 1.0 * dir);

	ss[0].pos = vec2(-1.0, 0.0); ss[0].rnd = 1.0; ss[0].rot = vec3(0.0, 0.0, 2.0); ss[0].scale = vec2(10.0, 1.0);
	ss[1].pos = vec2(0.0, 0.0); ss[1].rnd = 2.0; ss[1].rot = vec3(0.0, 0.0, 2.0); ss[1].scale = vec2(10.0, 1.0);

	vec3 color = vec3(0.0);
	
	for (int i = 0; i < 2; i+=1) {
		vec2 p1 = pos - ss[i].pos;
	
		float r = ss[i].rot.x + ss[i].rot.y * length(p1) + ss[i].rot.z * length(p1) * sign(pos.y);
	
		vec2 p2 = vec2(p1.x*cos(r)-p1.y*sin(r), p1.y*cos(r)+p1.x*sin(r))*ss[i].scale;
	
		float d = length(p2);
	
		// Nebulous cloud
		color = vec3(smoothstep(0.5, 0.0, d + cloud(vec3(p2, ss[i].rnd))*0.5)*10.0);
		color.r += 0.1;
	}
	
	gl_FragColor = vec4(color, 0.2);
}