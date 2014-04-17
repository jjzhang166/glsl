//thematica
#define PROCESSING_COLOR_SHADER

#ifdef GL_ES
precision mediump float;
#endif
#define PI2 6.28318530
#define pas 0.2
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 distancier(vec2 pos){
	float d=length(pos);
	
	float theta0=(pos.y<0.0)? PI2-acos(pos.x/d): acos(pos.x/d);
	float a=d/sin(2.0*theta0);
	float ecart=0.3+0.15*sin(time);
	float a0=floor(a/ecart)*ecart;
	float delta=abs(d-a0*sin(2.0*theta0));
	if( delta< 0.05 ){
		return vec3(1.0-delta*20.0,delta*delta*400.0,1.0-delta*delta*200.0);
	}
	return vec3(abs(sin(2.0*theta0)),delta*delta*20.0, 1.0-abs(sin(2.0*theta0)));
}

void main( void ) {

	vec2 p = (2.0*( gl_FragCoord.xy / resolution.xy )-1.0)*(2.0-1.95*sin(time*1.3));
	vec2 position=vec2(p.x*cos(time)-p.y*sin(time),p.x*sin(time)+p.y*cos(time));
	gl_FragColor = vec4(  distancier(position), 1.0);
}