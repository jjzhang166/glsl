#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 rot(vec2 v,float t){
	 float c=cos(t),s=sin(t);
	 return vec2(c*v.x-s*v.y,s*v.x+c*v.y);
}

void main( void ) {
	vec2 position = 2.0*( gl_FragCoord.xy / resolution.xy ) -1.0;
	
	float color = 0.0;
	float  q=0.0;
	vec2 p=position;
	for(int i=0;i<4;i++){
	vec2 c = rot( vec2(0.6, 0.), q+time*0.1);
	 p=rot(p-c,q+time*0.1)+c;
	color+= tan(p.x*cos(time*0.1) *p.y *50.)   ;
	q+=2.094395;
	}

	gl_FragColor = vec4( vec3( step(1.0,color) ), 1.0 );
}