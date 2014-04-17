/*
	Flower by @hintz
	2011-12-20
*/

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float flower(vec2 p)
{
  float r=p.x*p.x+p.y*p.y;
  float a=atan(p.y,p.x);
  
  return r+sin((a-time)*5.0);
}

vec3 color(float c)
{
  return vec3(sin(c-time),sin(c*2.1+1.0-time),sin(c*2.3+2.0+time));
}

void main() 
{
  vec2 position = (2.0*gl_FragCoord.xy-resolution.xy)/resolution.y;
  
  float c=flower(position);
 
  gl_FragColor = vec4(color(c),1.0);
}