#ifdef GL_ES
precision mediump float;
#endif

//
// Simple Path Tracer

uniform vec2 resolution;
uniform float time;
uniform float midFreq;
struct Ray
{
  vec3 org;
  vec3 dir;
};
struct Sphere
{
  vec3 c;
  float r;
  vec3 col;
  vec3 refl;
  int id;
};
struct Plane
{
  vec3 p;
  vec3 n;
  vec3 col;
  vec3 refl;
  int id;
};

struct Intersection
{
  float t;
  vec3 p;     // hit point
  vec3 n;     // normal
  int hit;
  vec3 col;
  vec3 refl;

  int id;
  Ray next;
};

void shpere_intersect(Sphere s, Ray ray, inout Intersection isect)
{
    // rs = ray.org - sphere.c
    vec3 rs = ray.org - s.c;
    float B = dot(rs, ray.dir);
    float C = dot(rs, rs) - (s.r * s.r);
    float D = B * B - C;

    if (D > 0.0)
    {
        float t = -B - sqrt(D);
        if ( (t > 0.0) && (t < isect.t) )
        {
            isect.t = t;
            isect.hit = 1;

            // calculate normal.
            vec3 p =  ray.org + ray.dir * t;
            vec3 n = p - s.c;
            n = normalize(n);
            isect.n = n;
            isect.p = p;
            isect.col = s.col;
            isect.refl = s.refl;
            isect.id = s.id;
        }
    }
}

void plane_intersect(Plane pl, Ray ray, inout Intersection isect)
{
    // d = -(p . n)
    // t = -(ray.org . n + d) / (ray.dir . n)
    float d = -dot(pl.p, pl.n);
    float v = dot(ray.dir, pl.n);

    if (abs(v) < 1.0e-6)
        return; // the plane is parallel to the ray.

    float t = -(dot(ray.org, pl.n) + d) / v;

    if ((t > 0.0) && (t < isect.t) )
    {
        isect.hit = 1;
        isect.t   = t;
        isect.n   = pl.n;

        vec3 p =  ray.org + ray.dir * t;
        isect.p = p;
        float offset = 0.2;
        vec3 dp = p + offset;
        if ((mod(dp.x, 1.0) > 0.5 && mod(dp.z, 1.0) > 0.5)
        ||  (mod(dp.x, 1.0) < 0.5 && mod(dp.z, 1.0) < 0.5))
            isect.col = pl.col;
        else
            isect.col = pl.col * 0.5;

        isect.refl = pl.refl;
        isect.id = pl.id;
    }
}

Sphere sphere[4];
Plane plane;
void Intersect(Ray r, inout Intersection i)
{
    for (int c = 0; c < 4; c++)
    {
        shpere_intersect(sphere[c], r, i);
    }
    plane_intersect(plane, r, i);
}

float rand1(inout vec2 co)
{
  float f = fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
  co.x = co.y;
  co.y = f;
  return f;
}

void main()
{
  float aspect = resolution.y / resolution.x;
  vec3 org = vec3(gl_FragCoord.xy / resolution.xy - vec2(0.5, 0.5) , 2.0 + 2.0 * sin(time));
  org.y *= aspect;
  vec3 camera_pos = vec3(0.0, 0.0, 3.0  + 2.0 * sin(time));
  vec3 dir = normalize(org - camera_pos);

  vec2 seed = vec2(time + gl_FragCoord.x, sin(time) + time + gl_FragCoord.y);

  sphere[0].c   = vec3(-2.0, 0.0, -3.5);
  sphere[0].r   = 0.5;
  sphere[0].col = vec3(1,0.3,0.3);
  sphere[0].refl = vec3(0.7, 0.0, 0.0);
  sphere[0].id   = 0;
  sphere[1].c   = vec3(-0.5, 0.0, -3.0);
  sphere[1].r   = 0.5;
  sphere[1].col = 32.0 * vec3(1.0, 0.9, 0.8);
  sphere[1].refl = vec3(0.0, 0.0, 0.0);
  sphere[1].id   = 1;
  sphere[2].c   = vec3(1.0, 0.0, -2.2);
  sphere[2].r   = 0.5;
  sphere[2].col = vec3(0.3,0.3,1);
  sphere[2].refl = vec3(0.0, 0.0, 0.0);
  sphere[2].id   = 0;
  sphere[3].c   = vec3(0.5, 0.0, -3.5);
  sphere[3].r   = 0.5;
  sphere[3].col = vec3(0.3,1.0,0.3);
  sphere[3].refl = vec3(0.0, 0.0, 0.0);
  sphere[3].id   = 0;
  plane.p = vec3(0,-0.5, 0);
  plane.n = vec3(0, 1.0, 0);
  plane.col = vec3(1, 1, 1);
  plane.refl = vec3(0.3, 0.0, 0.0);
  plane.id = 0;
  

  vec3 accum_col = vec3(0.0, 0.0, 0.0);
  for (int sample = 0; sample < 8;sample ++) {
    Ray r;
    r.org = org;
    r.dir = normalize(dir);
    float eps = 0.0001;
    Intersection i[8];
    int lastbounce = -1 ;
    for (int bounce = 0; bounce < 2; bounce ++) {
      i[bounce].hit = 0;
      i[bounce].t = 1.0e+30;
      i[bounce].n = i[bounce].p = i[bounce].col = vec3(0.0, 0.0, 0.0);
      Intersect(r, i[bounce]);

      if (i[bounce].hit == 1) { 
        if (i[bounce].id == 1) {
          lastbounce = bounce;
          break;
        }
        r.org = i[bounce].p + eps * i[bounce].n;

        if (i[bounce].refl.x > rand1(seed)) {      
          r.dir = reflect(r.dir, vec3(i[bounce].n.x, i[bounce].n.y, i[bounce].n.z));
        } else {
          for (int j = 0; j < 8; j ++) {
            float theta = rand1(seed) * 3.1415927;
            float phi   = rand1(seed) * 2.0 * 3.1415927;
            r.dir = vec3(sin(theta) * cos(phi), sin(theta) * sin(phi), cos(theta));
            if (dot(r.dir, i[bounce].n) >= 0.0) {
              break;
            }
          }
        }
         i[bounce].next = r;
      } else {
        i[bounce].col = vec3(0.0, 0.0, 0.0);
        break;
      }
    }

    vec3 now_col;
    for (int j = 3; j >= 0; j --) {
      if (j == lastbounce) {
        now_col = i[j].col;
      }

      if (j < lastbounce) {
        float c = dot(i[j].n, i[j].next.dir);
        now_col = now_col * c * i[j].col / (3.1415927 / 2.0);
      }
    }
    accum_col += now_col;
  }
  accum_col /= 8.0;
  accum_col.x = (accum_col.x / (1.0 + accum_col.x));
  accum_col.y = (accum_col.y / (1.0 + accum_col.y));
  accum_col.z = (accum_col.z / (1.0 + accum_col.z));
  gl_FragColor = vec4(accum_col, 0.0) ;
}