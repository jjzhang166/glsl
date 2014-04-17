#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
float x = gl_FragCoord.x;
void ww(vec2 a)
{
	float s = abs((distance(gl_FragCoord.xy, a)));
	s -= abs(gl_FragCoord.x - 120.);
	gl_FragColor += vec4( 9./s,3./s, 5./s, 1);
}
void w(vec2 a)
{
	float s = abs((distance(gl_FragCoord.xy, a)));
	s -= abs(x - 20.);
	gl_FragColor += .15*vec4( 9./s,3./s, 5./s, 1);
}
void a(vec2 b, float n, float r)
{
	if (abs(distance(gl_FragCoord.xy, b)) <r)
	{
	float  s = (gl_FragCoord.x*gl_FragCoord.y*.02 + .01*gl_FragCoord.y*gl_FragCoord.y - 650.)/250. - sin(gl_FragCoord.y*gl_FragCoord.x*gl_FragCoord.x);	
	gl_FragColor -= n*vec4(10./s,5./s,5./s,1);	
	}
}
void aa(vec2 b, float n, float r)
{
	if (distance(gl_FragCoord.xy, b) <r)
	{
	float  s = (gl_FragCoord.x*gl_FragCoord.y*.02 + .01*gl_FragCoord.y*gl_FragCoord.y - 650.)/250. - sin(gl_FragCoord.x*gl_FragCoord.x*gl_FragCoord.x);	
	gl_FragColor += n*vec4(1./s,1./s,1./s,1);	
	}
}
void s(float n, float t)
{
	float  s = (gl_FragCoord.y*gl_FragCoord.x*.008 + .01*gl_FragCoord.y*gl_FragCoord.x - n)/27. - sin(time/t*gl_FragCoord.x/3.);	
	gl_FragColor -= .1*vec4(4./s,9./s,3./s,1);
}
void g()
{
	float  s = (gl_FragCoord.y*gl_FragCoord.x*.008 + .01*gl_FragCoord.y*gl_FragCoord.x - 1000.)/163. - sin(gl_FragCoord.x*gl_FragCoord.y);	
	gl_FragColor += .2*vec4(8./s,8./s,8./s,1);
}
void www(vec2 a, float n)
{
	float d = 0., dd = 0.;
	for (int i = 0; i<=4; i++)
	{		
	        w(vec2(a.x+d,a.y + dd) / n);
		d+=10.; dd+=25.;
	        w(vec2(a.x+d,a.y + dd) / n);
		d+=5.; dd-=16.;	
	}
	dd =0.; d = -50.;		
	for (int i = 0; i<=4; i++)
	{		
	        w(vec2(a.x-d,a.y - dd) / n);
		d-=5.; dd-=20.;
	        w(vec2(a.x-d,a.y - dd) / n);
		d+=15.; dd+=10.;		
	}	
}
void u()
{
	float  s = (gl_FragCoord.x*gl_FragCoord.x*.008 + .01*gl_FragCoord.y*gl_FragCoord.y - 700.)/163. - tan(gl_FragCoord.x*gl_FragCoord.y);	
	gl_FragColor += .1*vec4(8./s*sin(time),8./s,8./s,1);
}
void main( void ) {	
	aa(vec2(100., 100.), .7, 100.);	
        ww(vec2(280.,430.));
	www(vec2(65.,170.), 1.);
	www(vec2(265.,230.), 2.);
	www(vec2(285.,270.), 1.7);
	www(vec2(865.,530.), 2.);
	www(vec2(585.,260.), 1.2);
	www(vec2(1165.,530.), 2.5);
	www(vec2(65.,130.), 2.1);
	www(vec2(305.,130.), 4.1);
	www(vec2(5.,70.), 3.1);
        a(vec2(500., 300.), 1.,60.);
	a(vec2(550., 250.), 1.3, 50.);
	a(vec2(470., 250.), 1.5, 40.);
	a(vec2(570., 200.), 1., 115.);
	s(1000.,10.); s(1300.,100.);
	g();
	u();	
}