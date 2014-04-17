#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float getValue(float x, float y, float t)
{
  float theta = atan(y, x);
  theta += time+t;
  float dx=cos(theta);
  float dy=sin(theta);
  float val = sqrt(x + dx) + sqrt(x + dy) ;
  
  return val*.45;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - vec2(1.0,resolution.y/resolution.x);
  
  	float x=position.x*2.;
  	float y=position.y*2.;
  	float r = getValue(x, y, .0);
  	float g = getValue(x, y, .1);
  	float b = getValue(x, y, .3);

	gl_FragColor = vec4( vec3( r*.7, g*.8, b*1.1), 1.0 );
}

