#ifdef GL_ES
precision mediump float;
#endif

#define ITERATIONS 5.0
// > NOTE: PLEASE HOLD YOUR RIGHT MOUSEBUTTON AND MOVE LEFT/UP TO ZOOM OUT FIRST
// > This has to be done after clicking "hide code"!
// > I don't know how to make a default scale for this, while still using surfacePosition.
//
// The default scale can be set just by multiplying  surfacePosition by a constant.
// There's no need to use "resolution" or 800x600 with surfacePosition as it takes
// resolution and aspect ratio into account (see below or "diff").  @emackey
 
//Parallax perlin noise
//By uitham
//NUMBERRR 1000!!!
//
// Changelog:
// +Added pan/zoom scrolling and scaling
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform vec2 surfaceSize;
//uniform sampler2D sceneTex; // 0
float vx_offset = 0.54;
float rt_w = 0.5; // GeeXLab built-in
float rt_h = 0.5; // GeeXLab built-in
float hatch_y_offset = 1.; // 5.0
float lum_threshold_1 = 0.7; // 1.0
float lum_threshold_2 = 0.6; // 0.7
float lum_threshold_3 = 0.5; // 0.5
float lum_threshold_4 = 0.4; // 0.3
varying vec2 surfacePosition;

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


void main( void ) {
	vec2 p = surfacePosition * 2000.0;  // Default scale multiplier
	p +=  1196.0;
	float z = 84.0;
	float speed = 10.0;
	float v = snoise(p / 128. + z + 0.05 * time * speed);
	p += 1017.0;
	for(float i = 1.0; i <= ITERATIONS; i++)
	{
		v +=  snoise(p / (64. / i) + z + 0.05 * time * speed) / (i * 2.);
	}
	v = 0.1 * v + 0.5;
	vec2 uv = p;

  vec3 tc = vec3(1.0, 0.0, 0.0);
  if (uv.x != (vx_offset-0.005))
  {
    float lum = length(v);
    tc = vec3(1.0, 1.0, 1.0);

    if (lum < lum_threshold_1)
    {
      if (mod(0.4 * gl_FragCoord.x , 1.0) < 0.5 ^^ mod(0.4 * gl_FragCoord.y, 1.) < 0.5)
        tc = vec3(0.0, 0.0, 0.0);
	else
		tc = vec3(1.0, 1.0, 1.0);
	    
    }  

    if (lum < lum_threshold_2)
    {
      if (mod(0.3 * gl_FragCoord.x , 1.0) < 0.5 ^^ mod(0.3 * gl_FragCoord.y, 1.) < 0.5)
        tc = vec3(0.0, 0.0, 0.0);
	else
		tc = vec3(0.3, 1.0, 0.5);
    }  

    if (lum < lum_threshold_3)
    {
      if (mod(0.2 * gl_FragCoord.x , 1.0) < 0.5 ^^ mod(0.2 * gl_FragCoord.y, 1.) < 0.5)
        tc = vec3(0.0, 0.0, 0.0);
	else
		tc = vec3(1.0, 0.5, 0.3);
    }  

    if (lum < lum_threshold_4)
    {
      if (mod(0.1 * gl_FragCoord.x , 1.0) < 0.5 ^^ mod(0.1 * gl_FragCoord.y, 1.) < 0.5)
        tc = vec3(0.0, 0.0, 0.0);
	else
		tc = vec3(0.5, 1.0, 0.3);
    }
  }
  else if (uv.x!=(vx_offset+0.005))
  {
    tc = vec3(v);
  }

	gl_FragColor = vec4(tc.x,tc.y, tc.z, v);
}