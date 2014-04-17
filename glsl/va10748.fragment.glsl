//catch them
#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float s,t,r,x=tan(time)*resolution.x/2.,y = sin(time)*resolution.y/2.;

float line(vec2 a, vec2 b,vec2 c, vec2 d,vec2 e, vec2 f)
{
	float y = distance(gl_FragCoord.xy, a) + distance(gl_FragCoord.xy, b) - 962.
		+distance(gl_FragCoord.xy, c) + distance(gl_FragCoord.xy, d) 
		-distance(gl_FragCoord.xy, e) + distance(gl_FragCoord.xy, f);
	return (y>0.)?y:1.;
}
float light()
{	
	vec2 point = mouse.xy*resolution.xy;	
	if (t>1.) return (distance(gl_FragCoord.xy,point)<15.)?0.8/distance(gl_FragCoord.xy,point):0.;
	else return 0.;
}
float catch(float sign)
{
	      return (abs(sign*x+resolution.x/2.-mouse.x*resolution.x)<20. && abs(y+resolution.y/2.-mouse.y*resolution.y)<20.)?
		  abs(2.*distance(gl_FragCoord.xy, vec2(sign*x+resolution.x/2.,y+resolution.y/2.)))
	          :abs(10.*distance(gl_FragCoord.xy, vec2(sign*x+resolution.x/2.,y+resolution.y/2.)));
}	
void main( void ) {		
	s = catch(1.);
	r = catch(-1.);		
	t = line (vec2(50.,400.),vec2(199.,116.), vec2(100.,200.),vec2(400.,200.), vec2(250.,250.),vec2(500.,250.));	
	float d = distance(gl_FragCoord.xy,vec2(100.,240.));	
	gl_FragColor = vec4(0.4/t/d*300.+light(), 20./r+light(),20./s,1);
}