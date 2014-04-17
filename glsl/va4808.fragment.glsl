#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

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

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float sampleRand(vec2 P, int dx, int dy)
{
	return rand(P + vec2(dx, dy));
}

float myNoise(vec2 P, out vec2 D) {
	vec2 i = floor(P);
	vec2 u = P-i;
	
	// cubic
	//u.x = smoothstep(0., 1., u.x);
	//u.y = smoothstep(0., 1., u.y);

	// derivatives
	float du = 30.0*u.x*u.x*(u.x*(u.x-2.0)+1.0);
    	float dv = 30.0*u.y*u.y*(u.y*(u.y-2.0)+1.0);
	
	// quintic
	u.x = u.x*u.x*u.x*(u.x*(u.x*6.0-15.0)+10.0);
    	u.y = u.y*u.y*u.y*(u.y*(u.y*6.0-15.0)+10.0);
	
	float a = sampleRand(i, 0, 0);
	float b = sampleRand(i, 1, 0);
	float c = sampleRand(i, 0, 1);
	float d = sampleRand(i, 1, 1);
	
	float k0 = a;
	float k1 = b - a;
	float k2 = c - a;
	float k3 = a - b - c + d;
	
	D.x = du*(k1 + k3*u.y);
	D.y = dv*(k2 + k3*u.x);
	
	return k0 + k1*u.x + k2*u.y + k3*(u.x*u.y);
			
	//return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 P, out vec2 D) {
	float f = 0.0;
	float w = 0.5;
	float x = 1.0;
	D.x = 0.0;
	D.y = 0.0;
	for (int i = 0; i < 4; ++i) {
		vec2 d;
		f += w*myNoise(x*P, d)/ (1.0 + dot(D, D));
		D += d;
		w *= 0.5;
		x *= 2.0;
	}
	
	return f;
}

void main( void ) {
	// xy in 0..1
	vec2 P = (gl_FragCoord.xy / resolution.xy) + 0.0*mouse;
	vec2 D;
	float N = fbm(8.0*P, D);
	gl_FragColor = vec4(0.5*(D+1.0), 0.0, 1.0);
	//gl_FragColor = vec4(N);
}