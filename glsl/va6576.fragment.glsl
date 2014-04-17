// @fizzer partycoding at BRBTITAN

// YASİNN !!

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


varying vec4 p, v, c, t2;
varying vec3 n;


vec2 rotate(float a, vec2 p)
{
   return vec2(cos(a) * p.x + sin(a) * p.y,
               cos(a) * p.y - sin(a) * p.x);
}

vec3 rotateX(float a, vec3 v)
{
   return vec3(v.x, cos(a) * v.y + sin(a) * v.z,
            cos(a) * v.z - sin(a) * v.y);
}

vec3 rotateY(float a, vec3 v)
{
   return vec3(cos(a) * v.x + sin(a) * v.z, v.y,
            cos(a) * v.z - sin(a) * v.x);
}

float cube(vec3 p, vec3 o, vec3 s)
{
   return length( max(vec3(0.0), abs(p - o) - s) );
}

float lobe(float e0, float e1, float x)
{
   return smoothstep(e0, (e0 + e1) * 0.5, x) - smoothstep((e0 + e1) * 0.5, e1, x);
}

float scene(vec3 p)
{
   p = rotateY(cos(time * 0.6) * 0.6, rotateX(sin(time) * 0.6, p));
   p += vec3(0.7, 0.0, 0.0);

   float rpc = 10.0;
   float c = 3.0;
   float cc = floor(time / c), cf = fract(time / c);

   
   float it = floor(time);
   float ft = fract(time);

   p = rotateX(cos(p.x * 2.0 + time * 3.0) * 0.3, p);

   float d = 1e10;

   d = min(d, cube(p, vec3(0.0, 0.0, 0.0), vec3(0.1, 0.2, 0.1))); // T
   d = min(d, cube(p, vec3(0.0, 0.15, 0.0), vec3(0.2, 0.05, 0.1))); // T
   d = min(d, cube(p, vec3(0.3, -0.08, 0.0), vec3(0.05, 0.12, 0.1))); // I
   d = min(d, cube(p, vec3(0.3, 0.15, 0.0), vec3(0.05, 0.05, 0.1))); // I
   d = min(d, cube(p, vec3(0.6, 0.0, 0.0), vec3(0.1, 0.2, 0.1))); // T
   d = min(d, cube(p, vec3(0.6, 0.15, 0.0), vec3(0.2, 0.05, 0.1))); // T
   d = min(d, cube(p, vec3(1.05, 0.15, 0.0), vec3(0.2, 0.05, 0.1))); // A
   d = min(d, cube(p, vec3(0.9, 0.0, 0.0), vec3(0.05, 0.2, 0.1))); // A
   d = min(d, cube(p, vec3(1.2, 0.0, 0.0), vec3(0.05, 0.2, 0.1))); // A
   d = min(d, cube(p, vec3(1.05, 0.0, 0.0), vec3(0.2, 0.02, 0.1))); // A

   d = min(d, cube(p, vec3(1.5, 0.15, 0.0), vec3(0.2, 0.05, 0.1))); // N
   d = min(d, cube(p, vec3(1.35, 0.0, 0.0), vec3(0.05, 0.2, 0.1))); // N
   d = min(d, cube(p, vec3(1.65, 0.0, 0.0), vec3(0.05, 0.2, 0.1))); // N

   float l = 0.02 + lobe(0.0, 0.15, fract(time)) * 0.1;

   return d - l;
}

vec3 gradient(vec3 p)
{
   float d = scene(p);
   float d0 = scene(p + vec3(1e-3, 0.0, 0.0));
   float d1 = scene(p + vec3(0.0, 1e-3, 0.0));
   float d2 = scene(p + vec3(0.0, 0.0, 1e-3));
   return vec3(d0 - d, d1 - d, d2 - d) / 1e-3;
}

float starsLayer(vec2 p)
{
   p *= vec2(4.0, 3.0);
   return clamp(1e-2 / abs(cos(p.x) * sin(p.y)) * cos(p.x + 3.1415926 * 0.5) * sin(p.y + 3.1415926 * 0.5), 0.0, 1.0);
}

vec3 stars(vec2 p)
{
   vec2 p2 = floor(p * 100.0) / 100.0;

   float b = fract(atan(p2.y, p2.x) / 3.1415926 * 10.0 + length(p2) * 3.0 * cos(time * 0.3) + cos(time * 0.5) * 2.0);

   b = smoothstep(0.4, 0.5, b) - smoothstep(0.9, 1.0, b);

   b *= (0.8 + 0.2 * cos(p.y * 200.0 * 3.1415926)) * (0.95 + 0.05 * cos(time * 40.0));

   return vec3(b) * 0.1 + vec3(starsLayer(rotate(-0.9, p * 4.0) + vec2(time * 0.1)) * 0.1 +
           starsLayer(rotate(0.1, p + vec2(time * 0.1))) +
      starsLayer(rotate(1.0, p * 2.0 + vec2(time * 0.1)))) * vec3(1.0, 1.2, 1.3) * 0.5;
}

float noise2(vec2 p)
{
   return fract(p.x * 0.4178423922 + p.y * 0.323934295);
}

float vignet(vec2 p)
{
   return 1.0 - (p.x * p.x * p.x * p.x  + p.y * p.y * p.y * p.y) * 0.5;
}

void main()
{
   vec2 t = gl_FragCoord.xy / resolution.xy * 2.0 - vec2(1.0);


   vec3 rd = normalize(vec3(t.xy, -0.7));
   vec3 ro = vec3(0.0, 0.0, 1.5);
   vec3 rp = ro;

   const int steps = 30;
   float i = 0.0;
   for(int j = 0; j < steps; j += 1)
   {
	
      float d = scene(rp);

      if(abs(d) < 1e-4)
         break;      

	   	i += min(1.0, 100.0 * d);

      rp += rd * d;      
   }

   vec3 n = normalize(gradient(rp));

   gl_FragColor.rgb = mix(vec3(0.6, 0.9, 0.9), vec3(1.0), 0.5 + 0.5 * dot(n, normalize(vec3(0.0, 1.0, 1.0))));

//gl_FragColor.rgb += vec3(noise2(gl_FragCoord.xy)) * 0.1;
//gl_FragColor.rgb *= 1.0 - i * 0.05;
	
	//gl_FragColor.rgb = vec3(i * 0.05);
	
   gl_FragColor.rgb *= vec3(1.0 - (float(i) - 1.0 - noise2(gl_FragCoord.xy) * 12.0) * 0.05);

   if(rp.z < -1.0)
      gl_FragColor.rgb = stars(t.xy) * smoothstep(0.0, 0.4, length(t.xy));

   gl_FragColor.rgb *= vignet(t.xy);

   gl_FragColor.a = 1.0;
}


