#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float getValue(vec2 p, float x2, float y2, float cmin, float cmax)
{
  float x=p.y*p.x;
  float y=p.y-p.x;
  float theta=atan(y-y2, x-x2);
  vec2 d=vec2(cos(theta), sin(theta));
  d *= abs(sin(time))* (cmax-cmin) + cmin;
  d += vec2(x2, y2);
  return length(d-p);
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - vec2(1.0,resolution.y/resolution.x);

  	float color = 0.0;
  	color += getValue(position, tan(time)*.1, sin(time)*.2, .3, .4);
  	color *= getValue(position, sin(time)*.2, cos(time)*.1, .3, .4);  
  	color *= getValue(position, tan(time)*.3, sin(time)*.2, .3, .4);
    	color *= getValue(position, sin(time)*.4, cos(time)*.1, .3, .4);
  	color = 1./color*.00002;
  
	gl_FragColor = vec4( vec3( color*0.5, color*0.5, color ), 1.0 );
}

