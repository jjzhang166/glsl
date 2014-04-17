//Edit @ToBSn

#ifdef GL_ES
precision highp float;
#endif
 
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float getValue(vec2 p, float x2, float y2, float t)
{
  float x=p.x;
  float y=p.y;
  float theta=dot(x2, y2);
  vec2 d = vec2(cos(theta), sin(theta)) * vec2(x, y);
  d *= vec2(y, y) / cos(p.y * t * 0.1) + dot(x,y);
  return length(d+d);
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - vec2(1.0,resolution.y/resolution.x);
  	p *= 16.0;
  
  	float t = time + 50000.0;

  	float a = 0.0;
  	a += getValue(p, sin(t)*.1, cos(t)*.2, t);
    	a *= getValue(p, sin(t)*.1, cos(t)*.2, t);
  	a += getValue(p, sin(t)*.1, cos(t)*.2, t);
  	a /= getValue(p, sin(t)*.1, cos(t)*.2, t);
  	a = 1./a;
  
  	float b = 0.0;
  	b += getValue(p, cos(t)*.1, sin(t)*.2, t);
    	b *= getValue(p, cos(t)*.1, sin(t)*.2, t);
  	b += getValue(p, cos(t)*.1, sin(t)*.2, t);
  	b /= getValue(p, cos(t)*.1, sin(t)*.2, t);
  	b = 1./b;
  
  	float c = 0.0;
  	c += getValue(p, sin(t)*.1, cos(t)*.2, t);
    	c *= getValue(p, sin(t)*.1, cos(t)*.2, t);
  	c += getValue(p, sin(t)*.1, cos(t)*.2, t);
  	c /= getValue(p, sin(t)*.1, cos(t)*.2, t);
  	c = 1./c;
  
	gl_FragColor = vec4( a, b, c, 1.0 );
}
