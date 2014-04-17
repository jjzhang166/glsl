//thematica
#define PROCESSING_COLOR_SHADER

#ifdef GL_ES
precision mediump float;
#endif
#define PI2 6.28318530
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
float func(float theta,float d){
float n=floor((0.75+mouse.y)*3.7);
return (d+3.0)/(d+cos(theta*n)+sin(theta*n));}

vec3 distancier(vec2 pos){
	float d=length(pos);	
	float theta0=(pos.y<0.0)? PI2-acos(pos.x/d): acos(pos.x/d);
	float a=d/func(theta0,d);
	float ecart=0.3+0.15*sin(time);
	float a0=floor(a/ecart)*ecart;
	float delta=mouse.x*abs(d-a0*func(theta0,d));
	if( delta<1.0 ){
		return vec3(cos(delta/d),3.0*delta*mouse.x,cos(delta));
	}
	return vec3(delta/d*mouse.x,cos(delta)*mouse.x,mouse.x*delta*d);
}

void main( void ) {
	float temps=time/4.0;
	vec2 p = (2.0*( gl_FragCoord.xy / resolution.xy )-1.0)*4.0;
	p.x*=resolution.x/resolution.y;
	p=vec2(p.x*cos(temps)-p.y*sin(temps),p.x*sin(temps)+p.y*cos(temps));
	 p= mod(p,4.0)-vec2(2.0,2.0);
	 p=vec2(p.x*cos(-temps)-p.y*sin(-temps),p.x*sin(-temps)+p.y*cos(-temps));
	 p=mod(p,2.0)-vec2(1.0,1.0);
	 temps*=-8.0;
	 p=vec2(p.x*cos(temps)-p.y*sin(temps),p.x*sin(temps)+p.y*cos(temps));
	 p=mod(p,1.0)-vec2(0.5,0.5);	
	gl_FragColor = vec4(  distancier(p), 1.0);}