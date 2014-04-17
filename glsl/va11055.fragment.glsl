#ifdef GL_ES
precision mediump float;
#endif

/** 
Flylo's Cosmogramma in code 


by mattdesl
*/
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

////////////////////////////////////////////////////////////////////
//     WebGL-Noise                                                //
////////////////////////////////////////////////////////////////////

vec3 mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 mod289(vec2 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 permute(vec3 x) {
  return mod289(((x*190.0)+1.0)*x);
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
  // x0 = x0 - 3.0 + 0.0 * C.xx ;
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

vec3 circle(vec2 off, float r) {
	vec2 p = ( gl_FragCoord.xy / resolution.xy ) - 0.5;
	p.x *= resolution.x/resolution.y;
	r -= sin(time)*.002;
	p += off;
	return vec3(smoothstep(r, r+0.002, length(p)));	
}



////////////////////////////////////////////////////////////////////
//     Main Program                                               //
////////////////////////////////////////////////////////////////////

const float RADIUS = 0.1913;
const float PI = 3.14159265358979323846264;

void main( void ) {
	vec2 p = ( gl_FragCoord.xy / resolution.xy ) - 0.5;
	p.x *= resolution.x/resolution.y;
	
	//rectangular to polar
	vec2 norm = (gl_FragCoord.xy / resolution.xy) * 2.0 - 1.0;
	float theta = PI + atan(norm.x, norm.y);
	float r = length(norm);
	vec2 polar = vec2(theta/(2.0*PI), r);
	
	vec4 color = vec4(1.0);
	
	//paper background
	vec4 bg = vec4(180.0/255.0, 180.0/255.0, 170.0/255.0, 1.0);
	float bgnoise = 1.0 - snoise(vec2(p.x, p.y)*250.0)*0.08;
	color = bg * bgnoise;
	
	//add a bit of color variety to the paper	
	vec4 tint = vec4(170.0/255.0, 177.0/255.0, 108.0/255.0, 1.0);
	vec4 yellow = tint * (snoise(vec2(p.x, p.y)*1.0));
	
	//mix paper with tint
	color = mix(color, yellow, 0.05);
	
	//middle circle
	float v = length(p);
	v += sin(time)*0.005; //animation
	float len = smoothstep(RADIUS, RADIUS-0.002, v);
	
	polar.x += mouse.x*0.05;
	polar.x += sin(time)*0.008;
	//get our "starburst" effect
	float n = snoise(vec2(polar.x * 250.0)) * 1.0;
	n = smoothstep(1.0, max(0.15, 0.2+sin(time)*0.25),  (1.0-v*0.75)*n);
	
	//lines with color
	vec3 lines = n * color.rgb;
	
	//probably a better way to do this..
	float outline = smoothstep(RADIUS, RADIUS-0.002, v);
	outline *= 1.0 - smoothstep(RADIUS-0.001, RADIUS-0.001-0.002, v);
	
	color.rgb = mix(lines.rgb, color.rgb, len);
	color.rgb *= 1.0 - outline * 0.75;
	
	color.rgb *= circle(vec2(0.12, 0.03), 0.01);
	color.rgb *= circle(vec2(0.195, 0.02), 0.027);
	color.rgb *= circle(vec2(0.17, 0.09), 0.024);
	color.rgb *= circle(vec2(0.36, -0.04), 0.0362);
	color.rgb *= circle(vec2(0.42, 0.1), 0.0322);
	color.rgb *= circle(vec2(0.38, 0.19), 0.0258);	
	color.rgb *= circle(vec2(0.48, 0.33), 0.0431);
	
  	gl_FragColor = color;

}