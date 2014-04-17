#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 p;

float band(float x) {
  return clamp((x-mod(x,.1)),0.,1.);
}

vec3 band(vec3 v) {
  return vec3(band(v.x),band(v.y),band(v.z));
}

float sphere(vec3 center, float radius, vec3 v) {
  return distance(center,v) - radius;
}

float cube(vec3 center, float radius, vec3 v) {
  return min(min(abs(v.x)-radius, abs(v.y)-radius), abs(v.z) - radius);
}

float dist(vec3 v) {
  v=vec3(v.x + .1*cos(8.*v.y+time), v.yz);
  return min(min(min(
    sphere(vec3(0),1.,v),
    sphere(vec3(2., 2.,0),.5,v)),
    v.y - -2.),
    8. - v.z);
}

vec3 normalat(vec3 v) {
  const float e=.01;
  float d0=dist(v);
  vec3 n = vec3(dist(v+vec3(e,0,0)),
    dist(v+vec3(0,e,0)),
    dist(v+vec3(0,0,e)))-vec3(d0);
  return normalize(n);
}

vec3 colorat(vec3 v) {
  return vec3(1.,1.,mod(v.y*5.,5.));
}

vec3 lightat(vec3 light, vec3 color, vec3 v, vec3 n) {
  vec3 tolight = normalize(light - v);
  return dot(tolight,n) * color;
}

vec3 draw() {
  vec3 eye = vec3(0,0,-6.);
  vec3 lens = vec3(mix(-1.5,1.5,p.x),
                              mix(1.,-1.,p.y),
                              -4.);
  vec3 ray = normalize(lens - eye);

  vec3 walk = eye;

  const int S=50;

  for(int i=0;i<S;i++) {
    float d = dist(walk);
    if(d<.01) break;
    walk += d * ray;
  }

  vec3 norm = normalat(walk);
  
  vec3 color = vec3(0);

  color +=
    lightat(vec3(1.,3.,-.5),
      vec3(0,1,0),walk,norm);

  color +=
    lightat(vec3(-2,-1.,-1),
      vec3(1,0,0),walk,norm);

  color +=
    lightat(vec3(2,-1.5,1.),
      vec3(0,0,1),walk,norm);

  return color;
  //return vec3(band(float(i)/float(S)));
  //return vec3(walk.z<.0?1.:0.);
}


void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	
	p = vec2(position.x, 1.-position.y);

	gl_FragColor = vec4(draw(),1.);
}