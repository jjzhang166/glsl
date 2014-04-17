#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 fn(vec3 v,float t){
	 float c=cos(t),s=sin(t);
	 return vec3(c*v.x-s*v.y,s*v.x+c*v.y,v.z*c-s*v.y);
}

void main( void ) {
	vec2 position = 2.0*( gl_FragCoord.xy / resolution.xy ) -1.0;
	position.y*=resolution.y/resolution.x;
	vec3 color = vec3(1.);
	float  q=0.0;
	vec3 p=vec3(position,0.);
	for(int i=0;i<8;i++){
	vec3 c = fn( vec3(1.,0.,0.), q );
	 p=fn(p-c,q+(time*0.015))+c;
	color+=tan(p.xyz)* tan(p.zzz)*tan(p.xxx) ;
	q+=0.785398;
	}
	gl_FragColor = vec4(fn(color,mouse.x*6.28), 1.0 );
}