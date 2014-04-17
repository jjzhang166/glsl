#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159

//messing around with projection

vec2 rotate(vec2 p,float d){
	return vec2(p.x*cos(d)-p.y*sin(d),
		    p.x*sin(d)+p.y*cos(d));
}

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy );
	pos.x-=0.5;
	
	vec3 color;
	
	float z=1.-pos.y;
	//magical projection
	pos.x/=z;
	pos.y/=z;
	
	pos=rotate(pos,mouse.x*PI*2.);
	
	color.rgb+=64.*sin(time*8.+PI*8.*pos.y);
	color.rgb+=64.*sin(PI*8.*pos.x);
	
	gl_FragColor = vec4(color,0);

}