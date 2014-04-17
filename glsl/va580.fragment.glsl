// By @ToBSn
//

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

const float amount = 0.15;

float makePoint(float x,float y,float fx,float fy,float sx,float sy,float t){
   float xx=x+sin(t*fx)*sx;
   float yy=y+cos(t*fy)*sy;
   return 1.0/sqrt(xx*xx+yy*yy);
}

void main( void )
{
	vec2 p=(gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);
	
	p = p * 4.0;
    
	float x = p.x;
	float y = p.y;

	float a = makePoint(x,x,1.3,2.9,0.3,-0.3,time);
	float b = makePoint(x,y,3.3,1.9,0.3,0.3,time);
	float c = makePoint(y,x,0.3,0.9,0.3,0.8,time);
       
	float angle = atan(y,x);
	float radius = length(p);
	angle += radius*amount * time * 0.2;
	vec2 shifted = cos(radius*vec2(cos(angle), sin(angle*time)));
  	vec4 bb = texture2D(backbuffer, shifted);
	gl_FragColor = vec4(a,b,c,1.0) - bb * 0.5; 
}