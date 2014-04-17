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

vec3 distancier(vec2 pos,float k){

	float d=length(pos);	
	float theta0=(pos.y<0.0)? PI2-acos(pos.x/d): acos(pos.x/d);
	float a=d/func(theta0,d);
	float ecart=0.3+0.15*sin(time);
	float a0=floor(a/ecart)*ecart;
	float delta=abs(d-a0*func(theta0,d));
	if( delta<1.0 ){
		return vec3(delta,3.0*delta*cos(mouse.x),mouse.x*delta);
	}
	return vec3(k*delta*mouse.x,5.*k*delta,2.0*cos(k));
}

void main( void ) {

	vec2 p = (2.0*( gl_FragCoord.xy / resolution.xy )-1.0)*5.0;	
	vec2 position=mod(p,4.0)-vec2(2.0,2.0);
	float k=(floor(position.x*3.0)+floor(position.y*3.0))/2.0;	
	 position=vec2(p.x*cos(time*k)-p.y*sin(time*k),p.x*sin(time*k)+p.y*cos(time*k));
	gl_FragColor = vec4(  distancier(position,k), 1.0);}
