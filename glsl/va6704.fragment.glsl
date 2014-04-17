#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float borderWidth = 1.5 / resolution.y;

vec3 rgb(int r, int g, int b) {
  return vec3(float(r) / 255.0, float(g) / 255.0, float(b) / 255.0);
}

vec2 position() {
  return vec2((gl_FragCoord.x - resolution.x), gl_FragCoord.y) / resolution.y;
}

float cross2(vec2 v0, vec2 v1) {
  return v0.x * v1.y - v0.y * v1.x;
}

float circle(vec2 centre, float radius) {
  return distance(centre, position()) - radius;
}

float ellipse(vec2 focus0, vec2 focus1, float radius) {
  vec2 p = position();
  return distance(p, focus0) + distance(p, focus1) - distance(focus0, focus1) * radius;
}

bool inside(float f) {
  return f < -borderWidth;
}

bool outside(float f) {
  return f > borderWidth;
}

vec3 borderColor = rgb(32, 32, 32);
vec3 hairColor0 = rgb(151, 200, 234);
vec3 hairColor1 = rgb(77, 135, 192);
vec3 hairColor2 = rgb(58, 103, 151);
vec3 faceColor0 = rgb(247, 223, 204);
vec3 faceColor1 = rgb(209, 173, 159);
vec3 faceColor2 = rgb(183, 148, 133);
vec3 eyeColor0 = rgb(145, 164, 176);
vec3 eyeColor1 = rgb(207, 216, 218);
vec3 eyeColor2 = rgb(255, 255, 255);
vec3 eyeColor3 = rgb(0, 0, 0);
vec3 eyeColor4 = hairColor0;
vec3 eyeColor5 = hairColor2;
vec3 eyeColor6 = hairColor1;
vec3 mouthColor0 = rgb(78, 53, 40);
vec3 mouthColor1 = rgb(152, 78, 69);
vec3 mouthColor2 = rgb(170, 92, 83);
vec3 backgroundColor = rgb(51, 124, 221);

bool ear0(out vec3 color) {
  vec2 p0 = vec2(-0.249, 0.192), p1 = vec2(-0.09, 0.25);
  float r0 = 0.202, r1 = r0 - distance(p0, p1);
  float c0 = circle(p0, r0), c1 = circle(p1, r1);
  float c = (cross2(position() - p0, p1 - p0) < 0.0) ? c1 : c0;
  if (outside(c))
    return false;
  color = inside(c) ? faceColor1 : borderColor;
  return true;
}
bool layer0(out vec3 color) {
	color=backgroundColor;
  return true;
}
bool layer1(out vec3 color) {
	color=backgroundColor;
  return true;
}
bool layer2(out vec3 color) {
	color=backgroundColor;
  return true;
}
bool layer3(out vec3 color) {
	color=backgroundColor;
  return true;
}
bool layer4(out vec3 color) {
	color=backgroundColor;
  return true;
}
bool layer5(out vec3 color) {
	if (inside(circle(vec2(-1.505, 1.15), 1.66)))
    return false;
 
  return ear0(color);
}

bool ikachan(out vec3 color) {
  if (layer4(color))
    return true;
  if (layer0(color))
    return true;
  if (layer5(color))
    return true;
  if (layer3(color))
    return true;
  if (layer1(color))
    return true;
  return layer2(color);
}
	
vec3 filter(vec3 color) {
  return color * 0.5 * (2.0 - gl_FragCoord.x / resolution.x + gl_FragCoord.y / resolution.y);
}

void main( void ) {

	
	vec3 color;
  	gl_FragColor = vec4(filter(ikachan(color) ? color : backgroundColor), 1.0);
}