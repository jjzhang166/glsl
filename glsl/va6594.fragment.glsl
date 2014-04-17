// fizzer \ @eddbiddulph

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


vec3 rotateY(vec3 v, float a)
{
   return vec3(v.x * cos(a) + v.z * sin(a),
               v.y,
               v.z * cos(a) - v.x * sin(a));
}

vec3 rotateX(vec3 v, float a)
{
   return vec3(v.x,
               v.y * cos(a) + v.z * sin(a),
               v.z * cos(a) - v.y * sin(a));
}

vec3 intersect(vec3 rd, float radius)
{
   return rd * radius / length(rd.xy);
}

float texDepth(vec2 coord)
{
   return clamp((distance(coord, vec2(0.5)) * 1.2 - 0.3 +
      cos(coord.x * 20.0) * sin(coord.y * 23.0) * 0.04) * 0.6 +
      cos(coord.x * 30.0) * 0.01
      , 0.0, 1.0);
}

vec3 tex(vec2 coord, float depth)
{
   return vec3(step(texDepth(coord), depth));

   return vec3(mix(step(0.5, coord.x), step(coord.x, 0.5),
              step(0.5, coord.y)));
}

vec3 mist(vec3 rd)
{
   vec3 ard = abs(rd);

   // project onto unit cube
   if(ard.x > ard.y && ard.x > ard.z)
      rd = vec3(sign(rd.x), rd.yz / ard.x);
   else if(ard.y > ard.x && ard.y > ard.z)
      rd = vec3(sign(rd.y), rd.xz / ard.y).yxz;
   else
      rd = vec3(rd.xy / ard.z, sign(rd.z));

   rd *= 10.5;
   rd += vec3(time, -time, 0.0);
   rd.x += cos(time + rd.y * 5.0);

   return vec3(1.5 + cos(rd.x) * sin(rd.y) * cos(rd.z));
}

#define EPS 0.001

vec3 tubeNormal(float angle, vec2 coord)
{
   float dc = texDepth(coord),
         dr = texDepth(coord + vec2(+EPS, 0.0)),
         dl = texDepth(coord + vec2(-EPS, 0.0)),
         du = texDepth(coord + vec2(0.0, -EPS)),
         dd = texDepth(coord + vec2(0.0, +EPS));
   
   vec3 v0 = vec3(+EPS, 0.0, dr - dc),
        v1 = vec3(0.0, -EPS, du - dc),
        v2 = vec3(-EPS, 0.0, dl - dc),
        v3 = vec3(0.0, +EPS, dd - dc);

   vec3 n0 = normalize(cross(v0, v1)),
        n1 = normalize(cross(v1, v2)),
        n2 = normalize(cross(v2, v3)),
        n3 = normalize(cross(v3, v0));

   vec3 tangentNormal = (n0 + n1 + n2 + n3) * 0.25;

   return rotateY(tangentNormal.xyz, angle).xzy;
}

float fluidHeight(vec2 p)
{
   p *= 0.1;
   return (cos(p.x * 80.0) * sin(p.y * 80.0 + time * 1.2) + 
          cos(p.x * 60.0) * sin(p.y * 50.0 + time * 2.0)) * 0.1;
}

vec3 fluidNormal(vec2 p)
{
   float h = fluidHeight(p);
   vec3 v0 = vec3(EPS, 0.0, fluidHeight(p + vec2(EPS, 0.0)) - h),
        v1 = vec3(0.0, EPS, fluidHeight(p + vec2(0.0, EPS)) - h);
   return normalize(cross(v1, v0));
}

float fluidTexture(vec2 p)
{
   vec2 c0 = vec2(p.x, mod(p.y * 1.1, 2.0));

   return distance(c0, vec2(0.0, 1.0)) * 3.0;
}

vec3 transformRay(vec3 v)
{
   return v;
}

vec3 transformPoint(vec3 p)
{
   return p;
}

vec3 nearestLight(vec3 p)
{
   float ll = 7.0, ss = 1.0;
   return vec3(ss + mod(floor(p.z / ll), 2.0) * -ss * 2.0, 0.0,
            floor(p.z / ll) * ll + ll * 0.5);
}

float nearestLightAmount(vec3 p)
{
   float ll = 7.0, ss = 1.0;
   float cell = floor(p.z / ll);

   if(mod(cell, 5.0) == 0.0)
   {
      return 1.0 + 0.1 * cos(time * 20.0 + cell);
   }

   return 1.0;
}


void main()
{
vec2 pos = gl_FragCoord.xy / resolution.xy * 2.0 - vec2(1.0);
   vec3 rd = transformRay(vec3(pos.x * resolution.x / resolution.y, pos.y, 1.0));

   vec3 ofs = vec3(0.0, 0.0, mod(time * 0.5, 100.0));

   gl_FragColor.a = 1.0;
   gl_FragColor.rgb = vec3(0.0);

   vec3 point = ofs;
   vec3 fluid_pos = rd * -0.7 / rd.y + ofs;

   const int n = 60;
   for(int i = n; i > 0; i -= 1)
   {
      float fi = float(i) / float(n);
      vec3 rp = intersect(rd, 1.0 + fi) + ofs;
      float angle = atan(rp.y, rp.x);
      vec2 coord = fract(vec2(angle / 3.14159 * 0.5, rp.z * 0.1) * 16.0);
      vec3 col = tex(coord, fi) / (1.0 + float(i) / 10.0);
   
      float g = col.x;

      vec3 light_pos = nearestLight(rp);
      float light_amount = nearestLightAmount(rp);
      vec3 light_dir = normalize(light_pos - rp).yxz;

      vec3 norm = tubeNormal(angle, coord);

      col *= (1.0 + dot(norm, vec3(-1.0, 0.0, 0.0))) * vec3(0.0, 0.2, 0.0) +
          light_amount * vec3(1.0, 1.0, 0.5) * max(0.0, dot(norm, light_dir) / distance(rp, light_pos));

      vec3 fluid_surf_colour = vec3(0.01, 0.1, 0.01) *
               fluidTexture(fluid_pos.xz);

      fluid_surf_colour *= 0.5 + light_amount * 2.0 * max(0.0, 0.3 + dot(fluidNormal(fluid_pos.xz).xzy,
            normalize(light_pos - fluid_pos))) / distance(fluid_pos, light_pos);

      if(rd.y > 0.0 || distance(rp, ofs) < distance(fluid_pos, ofs))
      {
         gl_FragColor.rgb = mix(gl_FragColor.rgb, col * 0.4, g);
      }
      else
      {
         gl_FragColor.rgb = mix(gl_FragColor.rgb,
           col * 0.35 * vec3(0.8, 1.0, 0.7) + fluid_surf_colour, g);
      }

      point = mix(point, rp, g);
   }

   float fog_amount = exp(-distance(point, ofs) / 50.0);
   vec3 fog_colour = mist(rd) * vec3(0.5, 0.6, 0.2);

   float fluid_fog_amount = exp(-distance(point, fluid_pos) / 5.0);
   vec3 fluid_fog_colour = vec3(0.5, 0.6, 0.2) * 0.4;

   if(point.y < -0.7)
      gl_FragColor.rgb = mix(fluid_fog_colour, gl_FragColor.rgb,
         fluid_fog_amount);

   gl_FragColor.rgb = mix(fog_colour, gl_FragColor.rgb,
         fog_amount);


   vec3 light_pos = transformPoint(nearestLight(ofs) - ofs);

   if(light_pos.z > 0.0)
{
   light_pos.xy = light_pos.xy / light_pos.z;   

   gl_FragColor.rgb +=  vec3(1.1, 1.0, 0.7) * clamp((1.0 - light_pos.z / 3.5) * 20.0, 0.0, 1.0) * vec3(0.1 /
         (light_pos.z * distance(pos.xy * vec2(1.3333, 1.0), light_pos.xy)));
}

gl_FragColor.rgb = pow(gl_FragColor.rgb, vec3(0.6));
}
