// Corrente Continua - 1k intro (win32)
// Zerothehero of Topopiccione
// 25/jul/2012

//@zerothehero: better formulas, visually improved

//Messed up by @zwa


#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const float di = 0.31243;
	
void main( void ) 
{
	float t = time*20.0;
	vec2 p=vec2(0.0, 0.0)-gl_FragCoord.xy /((resolution.y))*20.0;
	float x = (p.x*di-p.y*di*1.9);
	float y = (p.x*di*0.9+p.y*di);
	float z = log(di*di*1.9 + p.x * p.y);
	float a,b,c,d,e;
	for (int i=-0; i<10; i++) {
		c = (cos(x+t*(float(i))/9.9)+b+y+4.0);
		d = (cos(y+t*(float(i))/25.0)+x+a+5.0);
		e = (sin(y+t*(float(i))/17.5)+x-d+10.0);
		a -= cos(1.0/(c*c));
		b += 8.0/log(d*d);
		e += log(0.9 + z);
	}
	gl_FragColor = vec4(log(-e-a+b-1.)/1.-0.9,log(-e-a+b-1.)/2.9-0.2,log(-e-a+b-1.)/9.-0.1, 1.0) ;

}