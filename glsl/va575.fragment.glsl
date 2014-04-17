#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float getValue(vec2 p, float x2, float y2, float cmin, float cmax)
{
  float x=p.x;
  float y=p.y;
  float theta=atan(y-y2, x-x2);
  vec2 d=vec2(cos(theta), sin(theta));
  d *= abs(sin(time)) * (cmax-cmin) + cmin;
  d += dot(x2, y2) - length(p) * distance(x,y);
  return length(d-p);
}

void main( void ) {
	
  	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * 4.0 - vec2(2.0) ;
	position -= cos(time * 0.05) * vec2(cos(time*.01)+1.4, sin(time*.02)+1.6);
  
  	float l = length(position) *.25;
  
  	float wave2 = sin(cos(l)*500. - tan(time*0.5));
  	wave2 -= getValue(position * 2.1, cos(l)*.1, sin(time)*.2, .015,cos(time)*0.2);
  	wave2 += getValue(position /=5.1 , sin(time)*.1, cos(time)*.2, .015,sin(l)*0.2);
        wave2 += getValue(position *.2, cos(time*.1), sin(time*.1), .015,cos(time*0.2));
  	vec2 uv = gl_FragCoord.xy/resolution *cos(time * 0.25);
  	gl_FragColor = vec4(wave2*l, wave2*.4, wave2*.17, 0.) + texture2D(backbuffer,uv);

}