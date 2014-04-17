#ifdef GL_ES
precision mediump float;
#endif

//Indian Flag

//Ashok Gowtham M

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float pi=3.142;
void main( void ) {

	vec2 uv = ( gl_FragCoord.xy / resolution.xy );
	uv-=.5;
	uv.x*=resolution.x/resolution.y;
	//uv-=0.25;
	uv*=2.0;
//	uv.x*=resolution.y/resolution.x;
	vec4 col;
	uv.y+=sin(uv.x*10.0-time*2.0)/100.0;
	uv.y+=sin(uv.x*20.0-time*2.0)/100.0+uv.x/10.0;
	uv.y*=1.0+sin(uv.x*20.0-time*2.0)/100.0;
	uv.x+=sin(uv.x*10.0-time*2.0)/100.0;
	uv.x+=sin(uv.x*20.0-time*2.0)/100.0;

	vec2 ouv=uv;
	
	vec3 safron,white,green,navyblue;
	bool f1,f2,f3,f4;
	safron   = vec3(1.0,0.6,0.2);
	white    = vec3(1.0,1.0,1.0);
	green    = vec3(0.075,0.533,0.031);
	navyblue = vec3(0.0,0.0,0.5);
	
	uv+=.5;
	
	f1=uv.y>2.0/3.0;
	f2=uv.y>1.0/3.0 && uv.y<2.0/3.0;
	f3=uv.y<1.0/3.0;
	
	uv-=.5;
	uv*=2.0;
	
	float a,r;
	float f;
	r = length(uv)*4.0;
	a = (atan(-uv.y,-uv.x)+pi)/pi/2.0;
	
	f=abs(fract(a*24.0)-.5);
	f-=pow(2.0*pi*r,3.0)/exp(7.);
	
	f=smoothstep(0.2,0.21,f);
	//f=r;
//	f+=min(0.0,(abs(r)));
	//navyblue*=f;
	
	f4=true;
	f4=f>.99||(r<1.29&&r>1.1);
	//f4=uv.y>2.0/3.0;
	
	col.rgb = f1 ? safron   : col.rgb;
	col.rgb = f2 ? white    : col.rgb;
	col.rgb = f3 ? green    : col.rgb;
	col.rgb = f4 ? navyblue : col.rgb;
	
	ouv*=2.0;
	ouv.x*=2.0/3.0;
	col.rgb*=clamp((1.0-ouv.x)*(ouv.x+1.0)*1.0,0.0,1.0);
	col.rgb*=ouv.x<-1.0||ouv.x>1.0||ouv.y<-1.0||ouv.y>1.0?0.0:1.0;
	col.a = 1.0;
	gl_FragColor = col;

}



