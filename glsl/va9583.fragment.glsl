// Conway's Game of Life
// data stored alpha channel
// https://glsl.heroku.com/e#5129.2

// By Nop Jiarathanakul
// http://www.iamnop.com/

#ifdef GL_ES
precision highp float;
#endif

//---------------------------------------------------------
// MACROS 
//---------------------------------------------------------

#define EPS 0.0001
#define PI 3.14159265
#define HALFPI 1.57079633
#define ROOTTHREE 1.73205081

#define EQUALS(A,B) ( abs((A)-(B)) < EPS )
#define EQUALSZERO(A) ( ((A)<EPS) && ((A)>-EPS) )

//---------------------------------------------------------
// UNIFORMS
//---------------------------------------------------------

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

//---------------------------------------------------------
// GLOBALS
//---------------------------------------------------------

vec2 origin = vec2(0.0);
vec2 uv, pos, pmouse, uvUnit;
float aspect;
bool isLive;

//---------------------------------------------------------
// UTILS
//---------------------------------------------------------

float circle (vec2 center, float radius) {
  return distance(center, pos) < radius ? 1.0 : 0.0;
}

float rect (vec2 center, vec2 b) {
  vec2 bMin = center-b;
  vec2 bMax = center+b;
  return (
    pos.x > bMin.x && pos.y > bMin.y &&
    pos.x < bMax.x && pos.y < bMax.y ) ?
    1.0 : 0.0;
}

//---------------------------------------------------------
// PROGRAM
//---------------------------------------------------------

vec2 countNeighbors(vec2 p) {
  vec2 dir = texture2D(backbuffer, uv).xy-vec2(0.5,0.5);
	
if (length(dir)<0.1)
  #define KERNEL_R 1
  for (int y=-KERNEL_R; y<=KERNEL_R; ++y)
  for (int x=-KERNEL_R; x<=KERNEL_R; ++x) {
    vec2 spoint = uvUnit*vec2(float(x),float(y));
  	dir+=texture2D(backbuffer, uv+spoint).xy-vec2(0.5,0.5);
  
  }


  
  return dir;
}

vec2 gameStep() {
  isLive = texture2D(backbuffer, uv).a > 0.0;
  vec2 neighbors = countNeighbors(uv);
  
vec2 result =vec2(0,0);
if (length(neighbors)>0.7)
{
	neighbors=normalize(neighbors);
/*	if (neighbors.x>0.3)
	{	result.x=1.0;}
	
	if (neighbors.x<-0.3	)
	{result.x=-1.0;	}
	if (neighbors.y>0.3)
	{result.y=1.0;}
	if (neighbors.y<-0.3)
	{result.y=-1.0;}

*/
 result=neighbors;
	}

	return result;
	//return result;
}
vec3 ghosting() {
  #define DECAY 0.90
  return DECAY * texture2D(backbuffer, uv).rgb;
}

//---------------------------------------------------------
// MAIN
//---------------------------------------------------------

void main( void ) {
  aspect = resolution.x/resolution.y;
  uvUnit = 1.0 / resolution.xy;
  
  uv = ( gl_FragCoord.xy / resolution.xy );
  pos = (uv-0.5);
  pos.x *= aspect;
  
  pmouse = mouse-vec2(0.5);
  pmouse.x *= aspect;
  
  
  
  vec2 live = vec2(0.0,0);
  
  // seed shape
  float radius = 0.025;
  live +=vec2(0.5+0.5*sin(1.0*time),0.5+0.5*cos(1.0*time))* circle(pmouse, radius);
  
  // sim game
  live += gameStep();
  
  
  
  vec4 cout = vec4(0.5,0.5,0,0)+vec4(live,0,0);
  
  //cout=vec4(0.5,0.5,0,0);
  gl_FragColor = cout;
}
