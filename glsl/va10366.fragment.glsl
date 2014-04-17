//thematica
#define PROCESSING_COLOR_SHADER

#ifdef GL_ES
precision mediump float;
#endif
#define PI2 6.28318530
uniform float time;
uniform vec2 resolution;

float func(float theta,float d){return (d+3.0)/(d+cos(theta*3.0)+sin(theta*3.0));}

vec3 distancier(vec2 pos){
	float d=length(pos);
	
	float theta0=(pos.y<0.0)? PI2-acos(pos.x/d): acos(pos.x/d);
	float a=d/func(theta0,d);
	float ecart=0.3+0.15*sin(time);
	float a0=floor(a/ecart)*ecart;
	float delta=20.*abs(d-a0*func(theta0,d));
	if( delta< 1.0 ){
		return vec3(sin(delta*theta0),delta/8.0,cos(delta*theta0)*cos(delta));
	}
	return 0.3*vec3(cos(4.0*delta),cos(d/delta),0.2*delta);
}

void main( void ) {

	vec2 p = (2.0*( gl_FragCoord.xy / resolution.xy )-1.0)*10.0;
	vec2 position=vec2(p.x*cos(time)-p.y*sin(time),p.x*sin(time)+p.y*cos(time));
	gl_FragColor = vec4(  distancier(position), 1.0);}
