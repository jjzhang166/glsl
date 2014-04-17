#ifdef GL_ES
precision mediump float;
#endif

uniform vec4 vertColor;

int scale = 4;

vec3 camera = vec3(50.0, 0.0,-200.0);
const int MaximumRaySteps = 32;
float MinimumDistance = 1.;

vec3 lightpos = vec3(500, 250, 0);
vec3 diffuseColour = vec3(0.0, .70, 1.0);
float diffusePower = 500.0;
vec3 specularColour = vec3(1.0, 1.0, 1.0);
float specularPower = 500.0;
float specularHardness = 1.0;

float sdSphere(vec3 p, float r )
{
  return length(p)- r;
}

float sdTorus( vec3 p, vec2 t )
{
  vec2 q = vec2(length(p.xz)-t.x,p.y);
  return length(q)-t.y;
}

float DE(vec3 p)
{
  return sdSphere(p - vec3(700/scale, 300/scale, 0), 50.0/float(scale));
}

vec3 unpackColor(float f) {
    vec3 color;
    color.b = floor(f / 256.0 / 256.0);
    color.g = floor((f - color.b * 256.0 * 256.0) / 256.0);
    color.r = floor(f - color.b * 256.0 * 256.0 - color.g * 256.0);
    return color / 256.0;
}

vec4 trace(vec3 from, vec3 direction) {
  float totalDistance = 0.0;
  int outSteps;
  vec4 outCol = vec4(0.0,0.0,0.0,1.0);
  for (int steps=0; steps < MaximumRaySteps; steps++) {
    vec3 p = from + totalDistance * direction;
    float distance = DE(p);
    totalDistance += distance;
    if (distance < MinimumDistance) break;
    outSteps = steps;
  }
  
  float d = 1.0-float(outSteps)/float(MaximumRaySteps);
	
  
  outCol = vec4(d,d,d,1.0);
  
  return outCol;
}
void main() {
    vec3 pos = gl_FragCoord.xyz;
    vec4 col = trace(pos, pos);
    gl_FragColor = col;
}