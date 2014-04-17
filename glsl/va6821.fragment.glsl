// by neoman of titan
precision highp float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float       g_pi    = 2.0 * asin(1.0);
const float g_neps  = 0.01;
const float g_far   = 10.0;
const float g_trans = 2.0;
float       g_time  = time;

float tube(vec3 p, vec3 c)
{
   return length(p.xz - c.xy) - c.z;
}

vec3 twist(vec3 p)
{
   float t = time * 0.5;
   float c = cos(t + 8.1 * p.y);
   float s = sin(t + 8.1 * p.y);
   mat2 m = mat2(c,-s,s,c);
   vec2 p2d = m * p.xz;

   return vec3(p2d.x, p.y, p2d.y);
}

vec4 quaternion(float angle, float x, float y, float z) 
{
   return vec4(
      x * sin(angle * 0.5),
      y * sin(angle * 0.5),
      z * sin(angle * 0.5),
      cos(angle * 0.5)
   );
} 

vec3 rotate(vec3 p, vec4 q)
{
   vec3 t = cross(q.xyz, p) + q.w * p;
   return p + 2.0 * cross(q.xyz, t);
}

float f(vec3 p)
{
   vec4 q = quaternion(g_pi * 0.25, g_pi * 0.4, 0.0, 0.8);

   p = rotate(p, q);
   p += vec3(-0.1, time * 0.3, -0.0); // translate
   p = twist(p);

   return tube(
      p - vec3(sin(p.y * 5.0) * 0.3, 0.0, 0.0), 
      vec3(0.0, 0.0, 0.03)
   );
}

vec3 normal(vec3 h) 
{
   vec3 n = vec3(f(h + vec3(g_neps,   0.0, 0.0)) - f(h - vec3(g_neps,   0.0, 0.0)), 
                 f(h + vec3(0.0, g_neps,   0.0)) - f(h - vec3(0.0, g_neps,   0.0)), 
                 f(h + vec3(0.0, 0.0, g_neps))   - f(h - vec3(0.0, 0.0, g_neps)));
   return normalize(n);   
}

void main(void)
{
   vec3 color = vec3(0.0);
   vec2 pos = (( gl_FragCoord.xy / resolution.yy ) - 0.5) * 2.0;
   pos.x -= (resolution.x / resolution.y) * 0.5;
   vec3 ro = vec3(0.0, 0.0, 1.0);   
   vec3 rd = vec3(pos.x, pos.y, -1.0);

   float t = 0.0;
   int i = 0;   

   for(int i = 0; i < 100; i++)
   {
      float transdepth = 0.0;
      vec3 h = ro  + t * rd;
      float d = f(h);
      if(d < 0.01) 
      {        
         vec3 l = vec3(-0.5, 0.0, 0.5); // light
         float c = dot(normal(h), l);   // monsieur lambert
         float z = 1.0 - (t / g_far);   // falloff with distance

         color = z * mix(mix(vec3(0.0, 0.0, 0.3), vec3(1.0), c), color, 0.2); // diffuse and mix
         t += 0.01; // step behind volume (TODO: constant not good. replace by raycast? slow?) (use 0.01 for special fx lol)
         
         // we've a max. count of transparency levels
         transdepth += 1.0;
         if(transdepth == g_trans) break;
      } else {
         // TODO: adaptive step-size
         t += d * 0.2;
      }

      // reached far plane, break
      if(t >= g_far) break;
   }

   gl_FragColor = vec4(color * g_trans, 1.0);
}
