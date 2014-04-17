#ifdef GL_ES
precision mediump float;
#endif
//Ashok Gowtham M
//UnderWater Caustic lights
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
//normalized sin
float sinn(float x)
{
	return sin(x)/2.+.55;
}

float CausticPatternFn(vec2 pos)
{
	return (sin(pos.x*40.+time)
		+pow(sin(-pos.x*130.+time),1.)
		+pow(sin(pos.x*30.+time),2.)
		+pow(sin(pos.x*50.+time),2.)
		+pow(sin(pos.x*80.+time),2.)
		+pow(sin(pos.x*90.+time),2.)
		+pow(sin(pos.x*12.+time),2.)
		+pow(sin(pos.x*6.+time),2.)
		+pow(sin(-pos.x*13.+time),5.))/2.;
}

vec2 CausticDistortDomainFn(vec2 pos)
{
	pos.x*=(pos.y*.20+.5);
	pos.x*=1.+sin(time/1.)/10.;
	return pos;
}

vec3 lazer(vec2 pos, vec3 clr, float mult)
{
	vec3 color;
	// calc w which is the width of the lazer
	float w = fract(time*0.5);
	//w = sin(3.14156*w);
	w *= 1.5+pos.x;
	w *= 1.0;
	w = sin(w*1.0)*1.0;
	color = clr * mult * w / abs(pos.y);
	// add a ball
	float d = distance(pos,vec2(-1.0+fract(time*0.5)*2.,0.0));
	color += (clr * 0.25*w/d);
	return color;
}

void main( void ) 
{
	vec2 pos = gl_FragCoord.xy/resolution;
	pos-=.5;
	vec2  CausticDistortedDomain = CausticDistortDomainFn(pos);
	float CausticShape = clamp(7.-length(CausticDistortedDomain.x*20.),0.,1.);
	float CausticPattern = CausticPatternFn(CausticDistortedDomain);
	float CausticOnFloor = CausticPatternFn(pos)+sin(pos.y*100.)*clamp(2.-length(pos*2.),0.,1.);
	float Caustic;
	Caustic += CausticShape*CausticPattern;
	Caustic *= (pos.y+.5)/4.;
	//Caustic += CausticOnFloor;
	float f = length(pos+vec2(-.5,.5))*length(pos+vec2(.50,.5))*(1.+Caustic)/1.;
	
	
	
	
	vec2 pos2 = ( gl_FragCoord.xy / resolution.xy * 2.0 ) - 1.0;
	//pos.x *= resolution.x / resolution.y;
	vec3 color = max(vec3(0.2), lazer(pos2, vec3(1, 0.8, 2.), 0.15));
	gl_FragColor = vec4(color * 0.5, 1.0) + vec4(.1,.5,.6,1)*(f);
}