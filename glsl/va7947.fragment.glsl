///////DERP 
//by D.B.
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
	 float pi = 3.1415;


float mag(vec2 v){
	return sqrt(v.x*v.x  +  v.y*v.y);
}
float ang(vec2 v){
	if(v.x>0.0){
		
			return atan(v.y/v.x);
	}else{
		if(v.y>0.0){
			return atan(v.y/v.x)+pi;
		}
		else{
			return atan(v.y/v.x)-pi;
		}
	}
	
}
vec2 rot(vec2 v, float th){
	return vec2( v.x*cos(th) + v.y*sin(th)
		    ,-v.x*sin(th) + v.y*cos(th)  );
}
void main( void ) {
	
	vec2 p1 = vec2(gl_FragCoord.x,gl_FragCoord.y);
	vec2 pt;
	vec2 p2;
	vec2 pm = vec2(mouse.x,mouse.y);
	float clr = .50;
	float r,r2,th,phi;
	
	p2 = p1-pm;
	
	r = mag(p2);
	th = ang(p2);
	phi = 2.0*pi*sin(th)*(1.0/(0.01*mouse.x*r+1.0));
	p2 = rot(p2,phi+mouse.y) ;
	
	
	
	if( mod(p2.x,30.0)<=2.0 || mod(p2.y,30.0)<=2.0 || sin(p2.y)<=.0)
	{
		clr=p2.y;
	}
	
	gl_FragColor = vec4(clr,pm.y,p2.x, 1.0);

}
