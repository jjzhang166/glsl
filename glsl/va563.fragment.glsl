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
  float theta=atan(y-y2, x-x2);
  vec2 d=vec2(cos(theta), sin(theta * cmin));
  d *= abs(sin(time)) * (cmax-cmin) + cmin;
  d += vec2(x2, y2) + length(p) * dot(x,y);
  return length(d-p);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - vec2(1.0,resolution.y/resolution.x);
  	position = position * 6.0 * sin(time * .5) * cos(time * .2);

  	float color = 0.0;
  	color += getValue(position, tan(time)*.81, sin(time)*.2, 5.3, 0.8);
    	color *= getValue(position, cos(time)*.1, tan(time)*.2, 8.3, 0.18);
  	color += getValue(position, sin(time)*.8, cos(time)*.2, 4.3, 1.18);
  	color *= getValue(position, tan(time)*.8, cos(time)*.2, -1.3, 5.18);
  	color = 1./color*1.75;
  
	gl_FragColor = vec4( vec3( color * sin(0.4 * time), color *cos(time*0.8), color * cos(time) ), 1.0 );
}

