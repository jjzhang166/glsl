// @eddbiddulph

// An attempt to mimic the lights from cities and towns as seen from high above at night.

#ifdef GL_ES
precision mediump float;
#endif

#define EPS     vec2(1e-3, 0.0)
#define ONE     vec2(1.0, 0.0)
#define fbm2(g) fbm3(vec3(g, 0.0))

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

vec3 rotateX(float a, vec3 v)
{
   return vec3(v.x, cos(a) * v.y + sin(a) * v.z, cos(a) * v.z - sin(a) * v.y);
}

vec3 rotateY(float a, vec3 v)
{
   return vec3(cos(a) * v.x + sin(a) * v.z, v.y, cos(a) * v.z - sin(a) * v.x);
}

// Noise function
float N(vec2 p)
{
   p = mod(p, vec2(200.0)); // Attempt to fix precision issues.
   return fract(sin(p.x * 41784.0) + sin(p.y * 32424.0));
}

// Smooth noise for UV.
float smN2(vec2 p)
{
   vec2 fp = floor(p);
   vec2 pf = smoothstep(0.0, 1.0, fract(p));

   return mix( mix(N(fp), N(fp + ONE), pf.x), mix(N(fp + ONE.yx), N(fp + ONE.xx), pf.x), pf.y);
}

// Smooth noise for UVW.
float smN3(vec3 p)
{
   vec2 o = vec2(111.0);
   return mix(smN2(p.xy + floor(p.z) * o), smN2(p.xy + (floor(p.z) + 1.0) * o), smoothstep(0.0, 1.0, fract(p.z)));
}

// Fractal noise.
float fbm3(vec3 p)
{
   float f = 0.0, x;
   for(int i = 1; i <= 6; ++i)
   {
      x = exp2(float(i));
      f += (smN3(p * x) - 0.5) / x;
   }
   return f;
}

// A layer of stars.
float stars(vec2 p)
{
   vec2 ip = floor(p);
   vec2 fp = fract(p);
   return 0.002 / (0.5e-2 + distance(fp + vec2(fbm2(ip + vec2(170.0, 0.0)) * 2.0, fbm2(ip + vec2(0.0, 200.0)) * 2.0), vec2(0.5)));
}

void main()
{
   // Compute a ray direction and transform it by the inverse of the camera's orientation.
   vec2 aspect = vec2(resolution.x / resolution.y, 1.0);
   vec3 rd = rotateX(-0.3 + sin(time * 0.04) * 0.1 + -0.1 - mouse.y * 0.1, rotateY(cos(time * 0.03) * 0.1 - (mouse.x - 0.5) * 0.1, vec3((gl_FragCoord.xy / resolution.xy - vec2(0.5)) * 2.0 * aspect, -1.0)));

   // Intersect the ray with a plane.
   float t = -1.0 / rd.z;
   vec2 is = (rd * t).xy;

   vec2 p = is * 0.7 + vec2(time * 0.1, 0.0);
   float x = fbm2(p * 1.0 + vec2(170.0, 0.0)) + 0.3;
   float x0 = smoothstep(0.3, 0.31, x);
   float x1 = smoothstep(0.31, 0.45, x);

   x = x0 - x1;

   float c = 0.0;

   // Accumulate the layers.
   for(int i = 0; i < 9; i += 1)
   {
      float g = float(i) / 8.0;
      float f = stars(p * 40.0 + vec2(121.3  * float(i), float(i) * 1.3)) * smoothstep(0.01, 0.11, x - g);
      c += f * (1.0 - g);
   }

   c *= fbm2(p) + 0.5;

   // Blend in the layers of lights ('stars').
   gl_FragColor.rgb = vec3(1.0, 0.9, 0.7) * c * 5.0;
	
   // Add a subtle blue-green colour for the sea.
   gl_FragColor.rgb += vec3(0.0, 0.05, 0.1) * (1.0 - x0) * 0.02;
	
   // Darken the land and sea in the distance.
   gl_FragColor.rgb *= smoothstep(3.0, 0.5, t) * 1.5;
	
   // Add white clouds, with some noise to break up the quantization bands.
   gl_FragColor.rgb += vec3(fbm2(p * 1.0 + vec2(time * 0.2, 0.0)) + 0.5 + N(gl_FragCoord.xy) * 0.1) * 0.04;
	
   // Add a flat grey colour in the distance to simulate accumulating clouds in 3D.
   gl_FragColor.rgb += vec3(smoothstep(1.0, 6.0, t) * 0.2);
	
   gl_FragColor.a = 1.0;
}

