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

	vec4 col;
	
	vec3 safron,white,green,navyblue;
	bool f1,f2,f3,f4;
	safron   = vec3(1.0,0.6,0.2);
	white    = vec3(1.0,1.0,1.0);
	green    = vec3(0.075,0.533,0.031);
	navyblue = vec3(0.0,0.0,0.5);
	
	f1=uv.y>2.0/3.0;
	f2=uv.y>1.0/3.0 && uv.y<2.0/3.0;
	f3=uv.y<1.0/3.0;
	
	uv-=.5;
	uv*=2.0;
	
	float a,r;
	r = 1.0-length(uv);
	a = (atan(-uv.y,-uv.x)+pi)/pi/2.0;
	navyblue*=a;
	
	f4=true;
	//f4=uv.y>2.0/3.0;
	
	col.rgb = f1 ? white   : col.rgb;
	col.rgb = f2 ? white    : col.rgb;
	col.rgb = f3 ? green    : col.rgb;
	col.rgb = f4 ? navyblue : col.rgb;

	col.a = 1.0;
	gl_FragColor = col;

}