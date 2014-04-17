// by @eddbiddulph

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define EPS vec3(0.0001, 0.0, 0.0)


vec3 rotateZ(vec3 v, float angle)
{
   return vec3(cos(angle) * v.x - sin(angle) * v.y,
               cos(angle) * v.y + sin(angle) * v.x,
               v.z);
}

vec3 rotateY(vec3 v, float angle)
{
   return vec3(cos(angle) * v.x - sin(angle) * v.z,
               v.y,
               cos(angle) * v.z + sin(angle) * v.x);
}

vec3 rotateX(vec3 v, float angle)
{
   return vec3(v.x,
               cos(angle) * v.y - sin(angle) * v.z,
               cos(angle) * v.z + sin(angle) * v.y);
}

float pulse(float e0, float e1, float x)
{
   return step(e0, x) - step(e1, x);
}

float square(vec2 v0, vec2 v1, vec2 p)
{
   vec2 o = (v0 + v1) * 0.5, s = abs(v1 - v0) * 0.5;
   return length(max(vec2(0.0, 0.0), abs(p - o) - s)) - 0.001;
}

float circle(vec2 o, float r, vec2 p)
{
   return distance(p, o) - r;
}

float ellipse(vec2 o, vec2 r, vec2 p)
{
   vec2 e = (p - o) / r;
   vec2 n = o + normalize(e) * r;
   float d = distance(p, n);
   
   return mix(-d, +d, step(1.0, dot(e, e)));
}

// axis must be normalized
float cylinder(vec3 o, vec3 axis, float r,
      float l, vec3 p)
{
   float d = dot(p - o, axis);
   vec3 para = axis * d, perp = p - o - para;

   return length(max(vec2(0.0), vec2(length(perp) - r,
                     abs(d) - l * 0.5)));
}

// base of the slime is at (0.0, 0.0)
float slimeProfile(vec2 p)
{
   float a = ellipse(vec2(0.0, 0.3), vec2(1.5, 1.0) * 0.3, p);
   float b = square(vec2(0.0, 0.5), vec2(0.2, 0.94), p);
   float c = ellipse(vec2(0.22, 0.9965), vec2(0.2, 0.43), p);
   float d = ellipse(vec2(0.0, 0.94), vec2(0.02, 0.02), p);
   return min(a, min(d, max(b, -c)));
}

vec2 obj_union(vec2 a, vec2 b)
{
   return mix(a, b, step(b.x, a.x));
}

// base of the slime is at (0.0, 0.0, 0.0)
// stalk of slime points at +y
float slimeBodyDistance(vec3 p)
{
   return slimeProfile(vec2(length(p.xz), p.y));
}

vec2 slimeEyesObjectBlack(vec3 p)
{
   // inner
   float dist0 = min(cylinder(vec3(-0.1, 0.35, -0.38),
                         normalize(vec3(0.23, -0.38, 1.0)),
                         0.021, 0.11, p) - 0.01,
                    cylinder(vec3(+0.1, 0.35, -0.38),
                         normalize(vec3(-0.23, -0.38, 1.0)),
                         0.021, 0.11, p) - 0.01);

   // outer
   float dist1 = min(cylinder(vec3(-0.1, 0.35, -0.38),
                         normalize(vec3(0.23, -0.38, 1.0)),
                         0.07, 0.09, p) - 0.01,
                    cylinder(vec3(+0.1, 0.35, -0.38),
                         normalize(vec3(-0.23, -0.38, 1.0)),
                         0.07, 0.09, p) - 0.01);

   return vec2(min(dist0, dist1), 3.0);
}

vec2 slimeEyesObjectWhite(vec3 p)
{
   float dist = min(cylinder(vec3(-0.1, 0.35, -0.38),
                         normalize(vec3(0.23, -0.38, 1.0)),
                         0.06, 0.1, p) - 0.01,
                    cylinder(vec3(+0.1, 0.35, -0.38),
                         normalize(vec3(-0.23, -0.38, 1.0)),
                         0.06, 0.1, p) - 0.01);

   return vec2(dist, 2.0);
}

vec2 slimeEyesObject(vec3 p)
{
   return obj_union(slimeEyesObjectBlack(p),
                slimeEyesObjectWhite(p));
}

vec2 slimeBodyObject(vec3 p)
{
   return vec2(slimeBodyDistance(p), 1.0);
}

float slimeMouth2DShapeDistance(vec2 p, float expansion)
{
   vec2 o = vec2(0.0, 0.47);

   float a = max(0.0, max(-circle(o, 0.3, p),
                 circle(o, 0.31, p)));
   
   // cutoff for first end
   float cut0 = max(0.0, dot(p - o, normalize(vec2(2.0, 1.0))));

   // cutoff for second end
   float cut1 = max(0.0, dot(p - o, normalize(vec2(-2.0, 1.0))));

   return max(0.0, length(vec3(a, cut0, cut1)) - expansion);
}

vec2 slimeMouthObjectRed(vec3 p)
{
   float plane_dist = -0.415;

   vec3 rotcen = vec3(0.0, 0.2, plane_dist);
   p = rotateX(p - rotcen, 0.4) + rotcen;

   float a = abs(p.z - plane_dist);

   float dist = length(vec2(a, slimeMouth2DShapeDistance(p.xy, 0.007))) - 0.0101;

   return vec2(dist, 4.0);
}

vec2 slimeMouthObjectBlack(vec3 p)
{
   float plane_dist = -0.415;

   vec3 rotcen = vec3(0.0, 0.2, plane_dist);
   p = rotateX(p - rotcen, 0.4) + rotcen;

   float a = abs(p.z - plane_dist);

   float dist = length(vec2(a, slimeMouth2DShapeDistance(p.xy, 0.01))) - 0.01;

   return vec2(dist, 3.0);
}

vec2 slimeMouthObject(vec3 p)
{
   return obj_union(slimeMouthObjectBlack(p), slimeMouthObjectRed(p));
}

vec3 slimeBodyNormal(vec3 p)
{
   float dist = slimeBodyDistance(p);
   return normalize(vec3(slimeBodyDistance(p + EPS.xyz) - dist,
                         slimeBodyDistance(p + EPS.zxy) - dist,
                         slimeBodyDistance(p + EPS.yzx) - dist));
}

float toonDiffuse(vec3 n, vec3 l, vec3 v, float size, float interval)
{

   return clamp(1.0 - (acos(dot(n, l)) - size) / interval, 0.0, 1.0);
}


float toonSpecular(vec3 n, vec3 l, vec3 v, float size, float interval)
{
   vec3 h = normalize(l + v);

   return clamp(1.0 - (acos(dot(n, h)) - size) / interval, 0.0, 1.0);
}

float traceSlimeBody(vec3 ro, vec3 rd)
{
   float t = 0.0;

   for(int i = 0; i < 50; ++i)
   {
      float dist = slimeBodyDistance(ro + rd * t);

      if(abs(dist) < 0.0001)
         return t;

      t += dist * 0.9;
   }

   return t;
}



// p must be within unit square centred at 0.5, 0.5
vec3 slimeTileGraphic(vec2 p)
{
   p -= vec2(0.5);
   p.y -= 0.18;

   vec3 ro = vec3(0.0, 0.7, -1.5),
        rd = normalize(vec3(p.x, p.y, 1.0));

   vec3 lp = vec3(1.0, 2.0, -2.0);

   vec3 col = vec3(0.0);

   //ro = rotateX(rotateY(ro, time), time * 0.33);
   //rd = rotateX(rotateY(rd, time), time * 0.33);

   vec2 rot = vec2(cos(time * 0.6) * 0.1, sin(time) * 0.2);

   ro = rotateX(rotateY(ro, rot.y), rot.x);
   rd = rotateX(rotateY(rd, rot.y), rot.x);

   lp = rotateX(rotateY(lp, rot.y), rot.x);

   float t = 0.0;
   vec2 hit;

   for(int i = 0; i < 50; ++i)
   {
      vec3 p = ro + rd * t;

      hit = obj_union(obj_union(
               slimeBodyObject(p),
               slimeMouthObject(p)),
               slimeEyesObject(p));

      if(abs(hit.x) < 0.0001 || t > 4.0)
         break;

      t += hit.x * 0.9;
   }

   if(hit.y == 1.0) 
   {
      float t0 = t;
      vec3 p0 = ro + rd * t0;
   
      if(t0 < 4.0)
      {   
         float t1 = traceSlimeBody(ro + rd * 5.0, -rd);
         vec3 p1 = ro + rd * 5.0 - rd * t1;
   
         vec3 n0 = slimeBodyNormal(p0), l0 = normalize(lp - p0);
         vec3 n1 = -slimeBodyNormal(p1), l1 = normalize(lp - p1);
         vec3 v0 = ro - p0, v1 = ro - p1;
   
         float specfac0 = toonSpecular(n0, l0, v0, 0.1, 0.02);
         float is0 = toonDiffuse(n0, l0, v0, 0.8, 0.02);
   
         float specfac1 = toonSpecular(n1, l1, v1, 0.1, 0.4);
         float is1 = toonDiffuse(n1, l1, v1, 0.8, 0.4);
         
         vec3 diff = vec3(0.2, 0.2, 0.6) * 0.75,
               amb = diff * (0.8 + 0.2 * dot(l0, n0)),
              spec = vec3(1.0, 1.0, 1.0);
   
         amb = mix(gl_FragColor.rgb * 0.3, amb, 1.3 * exp(-distance(p0, p1)));
         diff = mix(gl_FragColor.rgb * 0.3, diff, 1.3 * exp(-distance(p0, p1)));
   
         col = (amb + is0 * diff + specfac0 * spec) +
                           0.2 * (amb + is1 * diff + specfac1 * spec);
   
      }
   }
   else if(hit.y == 2.0)
   {
      col = vec3(1.0);
   }
   else if(hit.y == 3.0)
   {
      col = vec3(0.0);
   }
   else if(hit.y == 4.0)
   {
      col = vec3(0.5, 0.1, 0.1) * 0.6;
   }

   return col;
}



void main()
{    gl_FragColor.a = 1.0; // Fix for the pitch-black gallery preview..
   gl_FragColor.rgb = slimeTileGraphic(gl_FragCoord.xy / resolution.xy * vec2(resolution.x / resolution.y, 1.0));
}
