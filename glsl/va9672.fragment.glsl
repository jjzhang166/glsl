#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec2 mu(vec2 u,vec2 v){return vec2( u.x*v.x-u.y*v.y,u.x*v.y+u.y*v.x);}

void main( void ) {
	vec2 p =2.0*( gl_FragCoord.xy / resolution.xy ) -1.0;
	p.x*=resolution.x/resolution.y;	
	p*=( 0.8 - 0.4*mouse.y );	
   	vec2 c=vec2( -0.707 , 0.26681 +  0.0015*sin(time*0.03) + 0.05*mouse.x);		
	for(int i = 0; i < 100; i++){p= mu(p, p)+c;}
	vec2 p1=smoothstep(0.0,1.0,p);
	gl_FragColor =vec4(pow(length(p1),0.1),tan(length(p1)/0.785),p1.x*p1.y,1.);
}
