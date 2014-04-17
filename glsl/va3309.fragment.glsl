// Corrente Continua - 1k intro (win32)
// Zerothehero of Topopiccione
// 25/jul/2012

//@zerothehero: better formulas, visually improved


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const float di = 0.707107;
	
void main( void ) 
{
	float t = time*20.;
	vec2 p=vec2(3.4,5.0)-gl_FragCoord.xy /((resolution.x))*18.0;
	float x = (p.x*di-p.y*di*0.9);
	float y = (p.x*di*0.9+p.y*di);
	float a,b,c,d,e;
	for (int i=-4; i<3; i++) {
		c = (sin(x+t*(float(i))/18.9)+b+y+4.0);
		d = (cos(y+t*(float(i))/20.0)+x+a+3.0);
		e = (sin(y+t*(float(i))/17.5)+x-d+1.0);
		a -= .2/(c*c);
		b += .4/(d*d);
		e += .1;
	}
	gl_FragColor = vec4(log(-e-a+b-1.)/8.-0.2,log(-e-a+b-1.)/8.-0.2,log(-e-a+b-1.)/5.-0.1, 1.0) ;

}