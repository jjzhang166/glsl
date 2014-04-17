// Corrente Continua - 1k intro (win32)
// Zerothehero of Topopiccione
// 25/jul/2012


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;



	const float di = 0.707107;
	
void main( void ) {
	float t = time*1.;
	vec2 p=vec2(.4,0.0)-gl_FragCoord.xy /((resolution.x))*5.0;
	float x = (p.x*di-p.y*di);
	float y = (p.x*di*2.9+p.y*di);
	float a,b,c,d,e;
	for (int i=-4; i<8; i++) {
		c = (sin(x+t*(float(i))/14.9)+b+y+4.0);
		d = (cos(y+t*(float(i))/60.0)+x+a+4.0);
		e = (sin(y+t*(float(i))/17.5)+x-d+4.0);
		a -= .2/c;
		b += 5.4/d;
		e += 1.1/e;
	}
	gl_FragColor = vec4(sqrt(-e+a+b)/8.-0.1,sqrt(-e+a+b)/8.-0.1,sqrt(-e+a+b)/5.-0.1, 1.0) ;

}