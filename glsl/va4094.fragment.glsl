// by rotwang
// tiny edit by timb

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
const float PI = 3.1415926535;
const float TWOPI = PI*2.0;



	
	
vec3 hsv2rgb(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}

float ring( vec2 p )
{
	float len = length(p)-0.55;
	len *= length(p*p)-0.66;
  	float d = len*len*512.0;

    return 1.0-d*d;
}


vec3 ring_clr( vec2 p )
{
	float d = ring( p );
	float angle = (atan(p.x, p.y)+PI)/TWOPI;
	angle += .01 * sin(time);
	float hue = angle;
	float lum = d;
	vec3 clr = hsv2rgb(hue,0.66,lum + .1 * sin(time) );

    return clr;
}

vec2 sincostime( vec2 p ){
	float y1 = sin(time/2.0) * 100.0;
	float x1 = sin(time/10.0) * 0.7;
	float x2 = cos(time/10.0) * 800.0 * sin(time/10.5) * 10.0;
	float x3 = sin(time/5.0) * .05;
	float y2 = cos(time/1.0) * 1.0;
	float y3 = sin(time/5.0) * 20.0;
	
	
	p.x=p.x+sin(p.x*x2+time)*x3-cos(p.y*x1-time)*1.95-sin(p.x*8.0+time)*0.2+cos(p.y*1.0-time)*0.1;
	
	p.y=p.y+sin(p.x*y1+time)*0.7+cos(p.y*y3-time)*y2+sin(p.x*4.0+time)*1.95-cos(p.y*6.0-time)*1.3;
	return p;
}

void main(void)
{

	vec2 unipos = (gl_FragCoord.xy / resolution);
	vec2 pos = unipos*2.0-1.0;
	pos.x *= resolution.x / resolution.y;

	pos=sincostime(pos);
	vec3 clr = ring_clr(pos);
	
	gl_FragColor = vec4(clr,1.0);
	
}