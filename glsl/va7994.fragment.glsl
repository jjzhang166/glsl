// たのしいレイトレ by @h013
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

struct Ray {
  vec3 org;
  vec3 dir;
};

struct Sphere {
  vec3 center;
  float radius;
  vec4 color;
  int materialID;
};

struct Intersection {
  float t;
  vec3 normal;
  vec3 hitpos;
  vec4 color;
  int materialID;
};

struct PointLight {
  vec4 color;
  vec3 center;
};

void checkIntersectionSphere(Ray ray, Sphere sphere, inout Intersection intersection) {
  vec3 op = sphere.center - ray.org;
  float b = dot(op, ray.dir);
  float det = b * b - dot(op, op) + sphere.radius * sphere.radius;
  if (det >= 0.0) {
    float sqrt_det = sqrt(det);
    float t1 = b - sqrt_det;
    float t2 = b + sqrt_det;
    float t;

    if (t1 > 1e-5 && t1 < intersection.t) {
      t = t1;
    } else if (t2 > 1e-5 && t2 < intersection.t) {
      t = t2;
    } else {
      return;
    }
    intersection.t = t;
    intersection.hitpos = ray.org + (t - 1e-2) * ray.dir;
    intersection.normal = normalize(intersection.hitpos - sphere.center);
    if (dot(ray.dir, intersection.normal) > 0.0)
      intersection.normal *= -1.0;
    intersection.color  = sphere.color;
    intersection.materialID = sphere.materialID;
  }
}

void checkIntersection(Ray ray, inout Intersection intersection) { 
  float tm = time*2.0;
  Sphere sphere0 = Sphere(vec3(-0.5 + 0.1 * sin(tm), 0.3 * cos(tm), 3.0 + 0.3 * sin(tm)),
   0.25, vec4(1.0, 0.5, 0.5, 0.0), 2);
  Sphere sphere1 = Sphere(vec3(0.0, -1000.0, 0.0), 999.0, vec4(1.0), 1);
  Sphere sphere2 = Sphere(vec3(0.0, 0.0, 1000.0), 995.0, vec4(1.0, 1.0, 1.0,0.0), 1);
  Sphere sphere3 = Sphere(vec3(1001, 0.0, 0.0), 999.0, vec4(1.0, 0.1, 0.1, 0.0), 1);
  Sphere sphere4 = Sphere(vec3(-1001, 0.0, 0.0), 999.0, vec4(0.1, 1.0, 0.1, 0.0), 1);
  Sphere sphere5 = Sphere(vec3(0, 1001, 0.0), 999.0, vec4(1.0, 1.0, 1.0, 0.0), 1);

  Sphere sphere6 = Sphere(vec3(0.76, -0.5, 2.0), 0.5, vec4(1.0, 0.0, 1.0, 0.0), 2);
  Sphere sphere7 = Sphere(vec3(-1.4, -0.5, 2.5), 0.5, vec4(0.1, 0.1, 1.0, 0.0), 1);
  Sphere sphere8 = Sphere(vec3(0.7, 0.5, 3), 0.5, vec4(1.0, 0.0, 1.0, 0.0), 2); // mat=3?

  
  // init
  intersection.t = 1e10;
  
  checkIntersectionSphere(ray, sphere0, intersection);
  checkIntersectionSphere(ray, sphere1, intersection);
  checkIntersectionSphere(ray, sphere2, intersection);
  checkIntersectionSphere(ray, sphere3, intersection);
  checkIntersectionSphere(ray, sphere4, intersection);
  checkIntersectionSphere(ray, sphere5, intersection);
  checkIntersectionSphere(ray, sphere6, intersection);
  checkIntersectionSphere(ray, sphere7, intersection);
  checkIntersectionSphere(ray, sphere8, intersection);
}

vec4 raytrace(Ray ray) {
  // Light
  PointLight pl[3];
  pl[0].color = vec4(1.0, 0.9, 0.9, 1.0) * 48.0;
  pl[0].center = vec3(-0.5, 1.0, -7.0 + abs(sin(time/2.0))*11.0);
  
  
  float eta = 1.5;

  for (int bounce = 0; bounce < 5; bounce ++) {
    Intersection intersection;
    checkIntersection(ray, intersection);
    if (intersection.materialID == 0) {
      return vec4(0.0);
    } else if (intersection.materialID == 1) {
        vec4 finalColor = vec4(0.0);
          Intersection shadowIntersection;
      
          vec3 lv = pl[0].center - intersection.hitpos;
          vec3 nlv = normalize(lv);
          Ray shadowRay = Ray(intersection.hitpos, nlv);
          checkIntersection(shadowRay, shadowIntersection);
		
          if (shadowIntersection.t > length(lv)) {
             finalColor += pl[0].color * intersection.color * vec4(vec3(max(dot(intersection.normal, nlv), 0.0)), 1.0) / 
             pow(length(lv), 2.0);
          }
        return finalColor;
    } else if (intersection.materialID == 2) {
      ray = Ray(intersection.hitpos, reflect(ray.dir, intersection.normal));
    } else {
      eta = 1.0 / eta;
      Ray tmpRay = Ray(intersection.hitpos + ray.dir * 0.01, refract(ray.dir, intersection.normal, eta));
      if (tmpRay.dir == vec3(0.0)) {
        eta = 1.0 / eta;
        ray = Ray(intersection.hitpos - ray.dir * 0.02, reflect(ray.dir, intersection.normal));
      } else {
        ray = tmpRay;
      }
    }
  }  
  return vec4(0.0);
}

void main() {
  vec2 nowPos = (gl_FragCoord.xy / resolution.xy - vec2(0.5, 0.5)) * 2.0;
  
  vec3 cameraCenter = vec3(0.0, 0.0, 0.0);
  vec3 screenCenter = vec3(0.0, 0.0, 1.0);
  vec3 cameraUp     = vec3(0.0, 1.0, 0.0);
  vec3 cameraSide   = normalize(cross(screenCenter - cameraCenter, cameraUp));
  
  vec2 screenSize   = vec2(1.0, resolution.y / resolution.x);  
  vec3 screenPos    = screenCenter + screenSize.x * nowPos.x * cameraSide + screenSize.y * nowPos.y * cameraUp;  

  Ray to = Ray(screenPos, normalize(screenPos - cameraCenter));


  vec4 ambient = vec4(0.1, 0.1, 0.15, 0.0);
  vec4 col = raytrace(to) + ambient;

  col = col / 8.0;  
  col = sqrt(col);
  
  gl_FragColor = col;
}






