// by rotwang

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
	
	float hue = angle;
	float lum = d;
	vec3 clr = hsv2rgb(hue,0.66,lum);

    return clr;
}


void main(void)
{

	vec2 unipos = (gl_FragCoord.xy / resolution);
	vec2 pos = unipos*2.0-1.0;
	pos.x *= resolution.x / resolution.y;

  
    vec3 clr = ring_clr(pos);
	
	
    gl_FragColor = vec4(clr,1.0);
}