
precision lowp float;



varying vec2 in_Texcoord;

uniform sampler2D tex0;
uniform sampler2D tex1;

uniform vec2 viewport;

const vec3 offset = vec3(0.0625, 0.5, 0.5);
const mat3 coeffs = mat3(
   1.164,  1.164,  1.164,
   1.596, -0.813,  0.0,
   0.0  , -0.391,  2.018 );
   
   



vec3 mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 mod289(vec2 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 permute(vec3 x) {
  return mod289(((x*34.0)+1.0)*x);
}

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
  i = mod289(i); // Avoid truncation effects in permutation
  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
		+ i.x + vec3(0.0, i1.x, 1.0 ));

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
// Posted by Trisomie21

uniform float time;
//float time = 0.5;
//uniform vec2 mouse;
uniform vec2 resolution;

// from http://glsl.heroku.com/e#5248.0
#define BLADES 7.0
#define BIAS 0.1
#define SHARPNESS 1.0
vec3 star(vec2 position) {
	//float blade = clamp(pow(sin(atan(position.y,position.x )*BLADES)+BIAS, SHARPNESS), 0.0, 1.0);
	float blade = clamp(sin(atan(position.y,position.x )*BLADES)+BIAS, 0.0, 1.0);
	vec3 color = mix(vec3(-0.34, -0.5, -1.0), vec3(0.0, -0.5, -1.0), (position.y + 1.0) * 0.25);
	color += (vec3(0.95, 0.65, 0.30) * 1.0 / distance(vec2(0.0), position) * 0.075);
	color += vec3(0.95, 0.45, 0.30) * min(1.0, blade *0.7) * (1.0 / distance(vec2(0.0, 0.0), position)*0.075);
	return color;

}


const float LAYERS	= 1.0;
const float SPEED	= 0.07;
const float SCALE	= 16.0;
const float DENSITY	= 0.2;
const float BRIGHTNESS	= 10.0;
       vec2 ORIGIN	= resolution.xy*.5;

float rand(vec2 co){ return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453); }

void main( void ) {
	
	vec2 in_Texcoord = ( gl_FragCoord.xy / resolution.xy );
	vec2 pos = 2.0 * in_Texcoord.xy - 1.0;//gl_FragCoord.xy - ORIGIN;
	
	//float dist = length(pos) / resolution.y;
	float dist = length(pos)  / sqrt(2.0);
	vec2 coord = vec2(pow(dist, 0.1), atan(pos.x, pos.y) / (3.1415926*2.0));
	vec3 color = vec3 (0.0,0.0,0.0);

	
	float a = pow((1.0-dist),20.0);
	float t = 10.0 - time;
		float r = coord.x - (t*SPEED);
		float c = fract(a+coord.y + .543);
		vec2  p = vec2(r, c*.5)*SCALE;
		vec2 uv = fract(p)*2.0-1.0;
		//float m = clamp((rand(floor(p) / 1000.0)-DENSITY)*BRIGHTNESS, 0.0, 1.0);
		float m = clamp((snoise(floor(p))-DENSITY)*BRIGHTNESS, 0.0, 1.0);
		color +=  clamp(star(uv*.5)*dist, 0.0, 1.0);
		//color +=  clamp(star(uv*.5)*m*dist, 0.0, 1.0);
	
	 vec4 t0 = vec4(coeffs*(vec3(texture2D(tex0, in_Texcoord).r, texture2D(tex1, in_Texcoord).ra) - offset), 1.0);
    
    //t0 *= 0.7;
    
    //gl_FragColor = mix(t0, vec4(color, 1.0), color.r );
    //gl_FragColor = (t0 + vec4(color, 1.0)) /2.0;
	//color = (color + vec3 (0.0,0.9,0.0)) /2.0;
	
	gl_FragColor = vec4(color, 1.0);
}