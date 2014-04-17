#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//frequency modulation graph thing, still learning

#define PI 3.14159

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy )-vec2(0.5,0.5);
	pos*=2.;
	float t=2.*PI*pos.x;
	float s=sin(t+8.*mouse.x*sin(t*8.*mouse.y));
	float c=1.;
	if(pos.y-0.04>s||pos.y+0.04<s){
		c=0.;
	}

	gl_FragColor = vec4(c);

}