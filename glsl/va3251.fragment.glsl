// Corrente Continua - 1k intro (win32)
// Zerothehero of Topopiccione
// 25/jul/2012


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const int bands = 4;


	const float di = 0.707107;
	
void main( void ) {
	float t = time*6.0;
	vec2 p=vec2(-1.0,0.0)-gl_FragCoord.xy /((resolution.x))*5.0;
	float x = (p.x*di-p.y*di);
	float y = (p.x*di*2.9+p.y*di);
	float a,b,c,d,e;
	for (int i=3; i<bands + 3; i++) {		
		c = (sin(x+t*(float(i))/14.9)+b*10.0+y+4.0) + 1.5;
		d = 1.5;//(cos(y+t*(float(i))/60.0)+x+a+4.0);
		e = 1.0;//(sin(y+t*(float(i))/17.5)+x-d+4.0);
		a -= .5/c;
		b += .4/d;
		e += .1/e;
	}
	
	float rColor =sqrt(-e+a+b)/8.-0.1;
	float gColor =sqrt(-e+a+b)/2.-0.1;
	float bColor =sqrt(-e+a+b)/5.-0.1;
	
	gl_FragColor = vec4(rColor,gColor,bColor, 1.0) ;

}