// By @ToBSn
//

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

const float amount = -0.2;

float makePoint(float x,float y,float fx,float fy,float sx,float sy,float t){
   float xx=x+tan(t*fx)*sx;
   float yy=y+tan(t*fy)*sy;
   return 1.0/length(xx*yy);
}

void main( void )
{
	vec2 p=(gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);
	
	p = p * 10.0;
    
	float x = p.x;
	float y = p.y;

	float a = makePoint(x,y,1.3,0.9,0.3,-0.3,time);
	float b = makePoint(x,y,1.3,0.3,0.3,0.3,time);
	float c = makePoint(x,y,1.1,0.9,0.6,-0.8,time);
       
	float angle = atan(x,y);
	float radius = length(p);
	angle -= radius * cos(amount + time);
	vec2 shifted = cos(radius*vec2(sin(angle), sin(angle)));
  	vec4 bb = texture2D(backbuffer, shifted);
	gl_FragColor = vec4(a,b,c,1.0) - bb; 
}