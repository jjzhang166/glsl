#ifdef GL_ES
precision mediump float;
#endif

// @hintz
// non-interacive version

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) 
{
	vec2 posScale = vec2(resolution.y,resolution.x)/sqrt(resolution.x*resolution.y);
	vec2 position = (( gl_FragCoord.xy / resolution.xy ) );
	
	float sum = 0.;
	float qsum = 0.;
	float t = time * 0.007 + mouse.y * 10.0;
	
	for (float i = 0.; i < 100.; i++) 
	{
		float x2 = i*.161235+cos(t+i*0.13)*0.1;
		float y2 = i*i*.3165+i*0.1+.5;
		vec2 p = (fract(position+0.01*t*vec2(x2,y2))-vec2(.8));
		float a = atan(p.x,p.y);
		float r = length(p)*100.;
		float e = exp(-r);
		sum += sin(sin(-r+a*2.0)+a+time)*e;
		qsum += e;
	}
	
	float color = sum/qsum;
	
	gl_FragColor = vec4(color,(color-.5)*(color+.5),-color, 1.0 );
}