#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec2 mu(vec2 u,vec2 v){return vec2( u.x*v.x-u.y*v.y,u.x*v.y+u.y*v.x);}

vec2 distv(vec2 p,vec2 c){
for(int i = 0; i < 40; i++){p= mu(p, p)+c;}
	return p;	
}

vec3 normal(vec2 p,vec2 c)
{
	vec2 eps= vec2(0.00000051, 0.0);	
	vec2 ce = distv(p,c);
	vec2 cf= distv(p,c+0.00000021);
    	vec3 dx =vec3(cf.x-ce.x, distv(p+eps.xy,c)-distv(p-eps.xy,c));
    	vec3 dy = vec3(cf.y-ce.y,distv(p+eps.yx,c)-distv(p-eps.yx,c));
    	return normalize(cross(dx,dy));	
}

void main( void ) {
	vec2 p =2.0*( gl_FragCoord.xy / resolution.xy ) -1.0;
	p.x*=resolution.x/resolution.y;	
	p=p*( 1.0 - 0.5*mouse.y )-0.1;	
   	vec2 c=vec2( -0.707 , 0.2  + 0.3*mouse.x);	
	float len=length(distv(p,c));	
	vec3 col=step(len,1.0)*(normal(p,c)+0.4);
	gl_FragColor =vec4(col,1.0);	
}
