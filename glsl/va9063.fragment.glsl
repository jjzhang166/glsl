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
  vec2 d=vec2(cos(theta), sin(theta));
  d *= abs(sin(time))* (cmax-cmin) + cmin;
  d += vec2(x2, y2);
  return length(d-p);
}

vec4 circles(vec2 p) {
	float color = 0.0;
	color += getValue(p, sin(time)*.06, sin(time)*.06, .68, .7);
	color *= getValue(p, cos(time)*.06, cos(time)*.06, .68, .7);
	color = 1./color*.0008;
	
	return vec4( vec3( color*.1, color*.2, color*0.3 ), 1.0 );
	
}

void main( void ) {
	
	//vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - vec2(1.0,1.0);
	
	vec4 circleShapes = circles(position);
	gl_FragColor = circleShapes; 
}