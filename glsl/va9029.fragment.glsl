// BRAVO!!!!!!!!!

// by @eddbiddulph

#ifdef GL_ES
precision mediump float;
#endif

#define EPS vec3(0.0001, 0.0, 0.0)

uniform float time;
uniform vec2 resolution;

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

vec2 obj_union(vec2 a, vec2 b)
{
   return mix(a, b, step(b.x, a.x));
}

float clampToZero(float x)
{
   return max(0.0, x);
}

float plane3D(vec3 n, float d, vec3 p)
{
   return dot(p, n) - d;
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


float chequerboard(vec2 p)
{
   return step(1.0, mod(p.x + step(1.0, mod(p.y, 2.0)), 2.0));
}

vec3 particle(vec3 start_pos, vec3 start_vel, 
              vec3 accel, float t)
{
   return start_pos + (start_vel + accel * t * 0.5) * t;
}
float curves(float outer_radius, float thickness,
             float amp, float freq, float phase, vec2 p)
{
   float inner_radius = outer_radius - thickness;
   float period = inner_radius * 2.0 + outer_radius * 2.0;

   float side = step(0.0, p.x);

   p.y = p.y * freq - (thickness + inner_radius * 2.0) * side;

   float cell = floor(p.y / period);   

   float r = cos((cell +
         side * 10.0) * 2.0 + phase) * amp + amp * 1.3;

   p.y = mod(p.y, period);

   float dist0 = ellipse(vec2(0.0, thickness + inner_radius), vec2(r + thickness * 0.5, outer_radius), p);
   float dist1 = ellipse(vec2(0.0, thickness + inner_radius), vec2(r - thickness * 0.5, inner_radius), p);

   float dist = max(dist0, -dist1);

   return 1.0 - smoothstep(-0.004, +0.004, dist);
}

vec2 texturedCurves(float outer_radius, float thickness,
             float amp, float freq, float phase, vec2 p)
{
   float inner_radius = outer_radius - thickness;
   float period = inner_radius * 2.0 + outer_radius * 2.0;

   float side = step(0.0, p.x);

   p.y = p.y * freq - (thickness + inner_radius * 1.0) * side;

   float cell = floor(p.y / period);

   float r = cos((cell +
         side * 10.0) * 2.0 + phase) * amp + amp * 1.5;

   p.y = mod(p.y, period);

   float dist0 = ellipse(vec2(0.0, thickness + inner_radius), vec2(r + thickness * 0.5, outer_radius), p);
   float dist1 = ellipse(vec2(0.0, thickness + inner_radius), vec2(r - thickness * 0.5, inner_radius), p);

   float dist = max(dist0, -dist1);

   vec2 delta = p - vec2(0.0, thickness + inner_radius);

   return vec2(cell * 2.0 + 1.0 * side + atan(delta.y, mix(-delta.x, delta.x, side)) / 3.1415926,
         (mix(dist1 / thickness, 1.0 - dist1 / thickness, side) - 0.5) * 2.0 );
}

vec2 curvePosition(float outer_radius, float thickness,
             float amp, float freq, float phase,
             float t)
{
   float inner_radius = outer_radius - thickness;
   float period = inner_radius * 2.0 + outer_radius * 2.0;

   float cell = floor(t), side = mod(cell, 2.0);
   float ang = fract(t) * 3.1415926;

   vec2 ofs = vec2(0.0, 0.75);

   float r = cos((cell +
         side * 10.0) * 2.0 + phase) * amp + amp * 1.5;

   vec2 p2 = vec2(0.0, cell) + ofs +
          vec2(sin(ang) * r, -cos(ang) * 0.5);

   p2.x = mix(-p2.x, p2.x, side);

   return p2;
}

vec3 pattern(vec2 p)
{
   vec3 col = vec3(0.0);

   col += 0.8 * vec3(1.0, 0.8, 0.3) * curves(0.25, 0.04, 0.25, 1.0, 0.0, p);
   col += 0.5 * vec3(1.0, 0.8, 0.3) * curves(0.25, 0.08, 0.25, 0.4, 100.0, p);
   col += 0.3 * vec3(1.0, 0.8, 0.3) * curves(0.25, 0.02, 0.25, 0.4, 100.0, p);

   return col;
}

vec3 floorTexture(vec2 p2)
{
   vec2 st = texturedCurves(0.4, 0.3, 0.25, 0.5, 0.0, p2);
   return pattern(st.yx);
}

float carProfileFront(vec2 p)
{
   return length(vec2(clampToZero(ellipse(vec2(0.0), vec2(0.16, 0.1), p)),
       clampToZero(square(vec2(0.0), vec2(1.0), p)))) - 0.06;
}

float carProfileMid(vec2 p)
{
   return square(vec2(-1.2, 0.0), vec2(0.0, 0.1), p) - 0.06;
}

float carProfileTop(vec2 p)
{
   return length(vec2(clampToZero(ellipse(vec2(-0.67, 0.13), vec2(0.5, 0.1), p)),
       clampToZero(square(vec2(-1.0, 0.16), vec2(1.0), p)))) - 0.06;
}

float carProfile(vec2 p)
{
   float dist = min(min(carProfileFront(p), carProfileMid(p)),
                  carProfileTop(p));

   dist = sqrt(pow(clampToZero(dist), 2.0) +
       pow(clampToZero(-circle(vec2(0.0,  -0.03), 0.22, p)), 2.0) + // front wheelspace
       pow(clampToZero(-circle(vec2(-1.0, -0.03), 0.22, p)), 2.0)) - 0.06; // back wheelspace
   
   return dist;
}

float carBodyDistance(vec3 p)
{
   return sqrt(pow(clampToZero(plane3D(vec3(0.0, 0.0, +1.0), 0.25, p)), 2.0) +
               pow(clampToZero(plane3D(vec3(0.0, 0.0, -1.0), 0.25, p)), 2.0) +
               pow(clampToZero(carProfile(p.xy)), 2.0)) - 0.03;
}

float carWheelsDistance(vec3 p)
{
   return min(
   cylinder(vec3(0.0, 0.0, 0.0), vec3(0.0, 0.0, 1.0), 0.15, 0.7, p),
   cylinder(vec3(-1.0, 0.0, 0.0), vec3(0.0, 0.0, 1.0), 0.15, 0.7, p));
}

vec2 carWheelsObject(vec3 p)
{
   return vec2(carWheelsDistance(p), 2.0);
}

vec2 carBodyObject(vec3 p)
{
   return vec2(carBodyDistance(p), 1.0);
}

float carDistance(vec3 p)
{
   return min(carBodyDistance(p), carWheelsDistance(p));
}

vec3 carNormal(vec3 p)
{
   float dist = carDistance(p);
   return normalize(vec3(carDistance(p + EPS.xyz) - dist,
                         carDistance(p + EPS.zxy) - dist,
                         carDistance(p + EPS.yzx) - dist));
}


const float roadscale = 6.0;

vec2 getCarPositions(out vec2 pos1, out vec2 pos2, out vec2 pos3,
                     float t)
{
   pos1 = curvePosition(0.4, 0.3, 0.25, 0.5, 0.0, t - 0.1);
   pos2 = curvePosition(0.4, 0.3, 0.25, 0.5, 0.0, t);
   pos3 = curvePosition(0.4, 0.3, 0.25, 0.5, 0.0, t + 0.1);

   return (pos1 + pos2 + pos3) * (1.0 / 3.0) * vec2(1.0, 1.0) * roadscale;
}

vec2 carDirection(vec2 pos1, vec2 pos2, vec2 pos3)
{
   return normalize(pos3 - pos1);
}

vec3 cam_translation, cam_target;

void transformRay(inout vec3 ro, inout vec3 rd)
{
   ro += cam_translation;

   vec3 w = normalize(cam_target - cam_translation),
        u = normalize(cross(vec3(0.0, 1.0, 0.0), w)),
        v = normalize(cross(w, u));
   
   rd = rd.x * u + rd.y * v + rd.z * w;
}

void transformObject(inout vec3 vertex)
{
   vertex -= cam_translation;

   vec3 w = normalize(cam_target - cam_translation),
        u = normalize(cross(vec3(0.0, 1.0, 0.0), w)),
        v = normalize(cross(w, u));

   vertex = vec3( dot(vertex, u), dot(vertex, v), dot(vertex, w));
}

vec3 traceFloor(vec3 ro, vec3 rd)
{
   return mix(vec3(0.0), floorTexture((ro.xz + rd.xz * -ro.y / rd.y) / roadscale),
           step(rd.y, 0.0));
}

void main()
{
   vec2 p = (gl_FragCoord.xy / resolution - vec2(0.5)) * 2.0 * vec2(resolution.x / resolution.y, 1.0);
   vec2 carpos1, carpos2, carpos3, carpos, cardir;

   carpos = getCarPositions(carpos1, carpos2, carpos3, time * 0.2);
   cardir = carDirection(carpos1, carpos2, carpos3);

   vec3 world_carpos = vec3(carpos.x, -0.1, carpos.y);

   float car_angle = atan(cardir.y, cardir.x);

   vec3 cam_ofs = vec3(cos(time * 0.7) * 3.0, cos(time * 0.333) * 2.0,
                       sin(time)) * 1.2;

   cam_translation = vec3(world_carpos.x, 2.7, world_carpos.z) + cam_ofs;
   cam_target = world_carpos;

   vec3 ro = vec3(0.0), rd = normalize(vec3(p.x, p.y, 1.0));
   transformRay(ro, rd);

   gl_FragColor.a = 1.0;
	
   // draw the floor
   gl_FragColor.rgb = traceFloor(ro, rd);



   // draw the car
   float t = 0.0;
   vec2 hit = vec2(0.0);
   vec3 rp = ro;

   bool car_hit = false;

   for(int i = 0; i < 70; ++i)
   {
      rp = rotateY(ro + rd * t - world_carpos,  -car_angle);

      hit = obj_union(carBodyObject(rp), carWheelsObject(rp));

      if(abs(hit.x) < 0.01)
      {
         car_hit = true;
         break;
      }

      t += hit.x;
      
      if(t > 10.0)
        break;
   }

   float max_z = 100.0; // this is for hiding particles

   if(hit.y == 1.0 && car_hit)
   {
      max_z = t;

      // get normal in world space
      vec3 norm = rotateY(normalize(carNormal(rp)), car_angle);

      gl_FragColor.rgb = vec3(0.75) * vec3(pow(0.5 + 0.5 *
               dot(norm, rd), 1.5));

      // reflect in world space
      rp = ro + rd * t;

      vec3 refl = normalize(rd - norm * dot(norm, rd) * 2.0);

      // reflection of floor
      gl_FragColor.rgb += traceFloor(rp, refl) * 0.8;
   }
   else if(hit.y == 2.0 && car_hit)
   {
      max_z = t;

      vec3 norm = normalize(carNormal(rp));

      gl_FragColor.rgb = 2.0 * vec3(0.5, 0.4, 0.2) *
            vec3(0.5 + 0.5 *
            dot(norm, normalize(vec3(1.0, 1.0, 0.0))));
   }

   // draw the particles
   float period = 0.6;
   for(float x = 0.0; x < 1.0; x += 0.04)
   {
      float y = time * 0.2 + x * period;
      float cell = floor(y / period) - x;
      float t = mod(y, period);
      float car_t = cell * period;
      
      carpos = getCarPositions(carpos1, carpos2, carpos3, car_t);
      cardir = carDirection(carpos1, carpos2, carpos3);

      float car_angle = atan(cardir.y, cardir.x) - 3.1415926 * 0.5;
      vec3 world_carpos = vec3(carpos.x, -0.1, carpos.y);

      vec3 objpos = particle(world_carpos + vec3(cardir.x, 0.0, cardir.y) * -1.3,
         vec3(0.0, 2.5, 0.0) + rotateY(vec3(0.0, 0.0, -1.0),
         car_angle + cos(cell * 100.0) * 0.9 ), vec3(0.0, -1.5, 0.0), t * 5.0);
            
      // transform the object
      transformObject(objpos);
      
      if(objpos.z > 0.0 && objpos.z < max_z)
      {
         float r = 0.02 / objpos.z;
         vec2 proj = objpos.xy / objpos.z;
         gl_FragColor.rgb += r / distance(p.xy, proj) *
            (1.0 - t / period) * vec3(1.0, 0.9, 0.7) * 
            (1.0 - smoothstep(max_z - 0.2, max_z, objpos.z)) *
           (1.5 + sin(cell * 123.0));
      }
   }
}

