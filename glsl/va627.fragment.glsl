//Edit @ToBSn

#ifdef GL_ES
precision mediump float;
#endif
 
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float getValue(vec2 p, float x2, float y2, float cmin, float cmax)
{
  float x=p.x;
  float y=p.y;
  float theta=dot(y-y2, x2);
  vec2 d = vec2(-cos(theta * x2), cos(theta - cmin));
  d *= sin(time * 0.1) * (cmax-cmin) + cmin;
  d += vec2(y, x) + length(p) * distance(y,x);
  d *= vec2(x, y) * cos(p * time * 0.1) * dot(x,y);
  return length(d-p);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - vec2(1.0,resolution.y/resolution.x);
  	position = position * 5.0 ;

  	float a = sin(time*.5+position.x);
  	a += getValue(position, sin(time)*.1, cos(time)*.2, 5.3, 0.8);
    	a *= getValue(position, sin(time)*.1, cos(time)*.2, 5.3, 0.8);
  	a += getValue(position, sin(time)*.1, cos(time)*.2, 5.3, 0.8);
  	a /= getValue(position, sin(time)*.1, cos(time)*.2, 5.3, 0.8);
  	a = 1./a;
  
  	float b = sin(time+position.y*1.5);
  	b += getValue(position, cos(time)*.1, sin(time)*.2, 5.3, 0.8);
    	b *= getValue(position, cos(time)*.1, sin(time)*.2, 5.3, 0.8);
  	b += getValue(position, cos(time)*.1, sin(time)*.2, 5.3, 0.8);
  	b /= getValue(position, cos(time)*.1, sin(time)*.2, 5.3, 0.8);
  	b = 1./b;
  
  	float c = sin(time*.8+length(position)*8.0);
  	c += getValue(position, sin(time)*.1, cos(time)*.2, 5.3, 0.8);
    	c *= getValue(position, sin(time)*.1, cos(time)*.2, 5.3, 0.8);
  	c += getValue(position, sin(time)*.1, cos(time)*.2, 5.3, 0.8);
  	c /= getValue(position, sin(time)*.1, cos(time)*.2, 5.3, 0.8);
  	c = 1./c;
  
	gl_FragColor = vec4( a, b, c, 1.0 );
}
