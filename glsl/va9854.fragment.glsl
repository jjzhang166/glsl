#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;

float PI=3.14;

vec2 view(in vec2 obj0,in vec2 obj1){
 return obj0.x < obj1.x ? obj0 : obj1;
}

vec2 obj0(in vec3 p){
  return vec2(1, 0);
}

vec3 penis_color(in vec3 p){
  return vec3(1.0,0.5,0.4);
}

vec2 shaft(vec3 p, float r, float c) {
  return vec2(mix(length(p.xz)-r, 
		  length(vec3(p.x, abs(p.y)-c, p.z)) - r,
		  step(c,abs(p.y))),
	      1.);
}

vec2 comp(in vec3 p){
  vec2 r = obj0(p);
  vec3 q = p + vec3(0., -.25-3.*abs(sin(time * 15.0)), 0.);
	q.x += 5.0 * sin(time * 5.);
	q.z += 5.0 * cos(time * 3.);
	
	r = view(r, shaft(q, .5, 1.5));
	r = view(r, vec2(length(q+vec3(-.5, 1.5, 0.)) - 0.75, 1.));
	r = view(r, vec2(length(q+vec3(.5, 1.5, 0.)) - 0.75, 1.));
	r = view(r, vec2(length(q+vec3(0, -1.5, 0.)) - .75, 1.));
	
  return r;
}
 
vec3 camera(vec3 prp) {
  vec2 vPos= -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;

  vec3 vuv = vec3(0, 1, 0);
  vec3 vrp = vec3(0.0, 0, 0);

  vec3 vpn = normalize(vrp - prp);
  vec3 u = normalize(cross(vuv, vpn));
  vec3 v = cross(vpn, u);
  vec3 vcv = (prp + vpn);
  vec3 scrCoord = vcv + vPos.x * u * resolution.x / resolution.y + vPos.y * v;
  return normalize(scrCoord - prp);
}

void main(void) {
  float f=1.0;

  vec2 s=vec2(0.1,0.0);
  vec3 prp, c,p,n;

  vec3 scp = camera(prp = vec3(5.0));

  for(int i= 0; i<64; i++) {
    f += s.x;
    p = prp + scp * f;
    s = comp(p);
  }
  
    c = s.y == 0.0 ? floor(p) : penis_color(p); 
 
    const float n_er = 0.01;
    float v1=comp(vec3(p.x + n_er, p.y - n_er, p.z - n_er)).x;
    float v2=comp(vec3(p.x - n_er, p.y - n_er, p.z + n_er)).x;
    float v3=comp(vec3(p.x - n_er, p.y + n_er, p.z - n_er)).x;
    float v4=comp(vec3(p.x + n_er, p.y + n_er, p.z + n_er)).x;
    n=normalize(vec3(v4 + v1 - v3 - v2, v3 + v4 - v1 - v2, v2 + v4 - v3 - v1));
    
    float b = dot(n, normalize(prp - p));
    gl_FragColor=vec4(b * c + pow(b, 11.0) * (1.0 - f * .01),
		      0);
}