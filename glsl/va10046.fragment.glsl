#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
//normalized sin
float sinn(float x)
{
	return sin(x)/2.+.5;
}

float CausticPatternFn(vec2 pos)
{
	return (sin(pos.x*40.+time)
		+pow(sin(-pos.x*130.+time),2.)
		+pow(sin(pos.x*30.+time),3.)
		+pow(sin(pos.x*50.+time),2.)
		+pow(sin(pos.x*80.+time),4.)
		+pow(sin(pos.x*90.+time),7.)
		+pow(sin(pos.x*12.+time),1.)
		+pow(sin(pos.x*6.+time),4.)
		+pow(sin(-pos.x*13.+time),5.))/2.;
}

vec2 CausticDistortDomainFn(vec2 pos)
{
	pos.x*=(pos.y*0.30+1.);
	pos.x*=2.+sin(time/4.)/1.;
	return pos;
}

void main( void ) 
{
	vec2 pos = gl_FragCoord.xy/resolution;
	pos-=.5;
	vec2  CausticDistortedDomain = CausticDistortDomainFn(pos);
	float CausticShape = clamp(7.-length(CausticDistortedDomain.x*20.),0.,1.);
	float CausticPattern = CausticPatternFn(CausticDistortedDomain);
	float CausticOnFloor = CausticPatternFn(pos)+sin(pos.y*200.)*clamp(2.-length(pos*2.),0.,1.);
	float Caustic;
	Caustic += CausticShape*CausticPattern;
	Caustic *= (pos.y+.5)/4.;
	//Caustic += CausticOnFloor;
	float f = length(pos+vec2(-.5,.5))*length(pos+vec2(.5,.5))*(1.+Caustic)/1.;
	
	
	gl_FragColor = vec4(.3,.9,.6,3)*(f);

}