// fuck that shit.

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define numLegs 13.0	//non integers look terrible

void main(void) {

	vec2 p = -1.0+2.0*gl_FragCoord.xy/resolution.xy;
	float dist		= length(p);
	
	float w = -sin(sqrt(dot(p,p)*(sin(cos(time*5.0))*3.0+15.0))+time*3.0); 	//part 2 -- bend
	float x = cos(numLegs*atan(p.y,p.x) + 5.0*w);	//part 1 -- legs and fade
	
	vec3 brightColor = vec3(0.5,-0.5,-0.7)*5.0;
	float brightColorFade = min( max( 0.7 - dist * 0.7 , 0.1 ), 0.5 );
	
	vec3 col = vec3(brightColor*x*(sin(cos(time*2.0))*0.3+0.8)*brightColorFade);
	col.r *= mod(gl_FragCoord.y, 2.0)*(sin(time)*0.2+0.4);
	
	gl_FragColor = vec4(col, 1.0);
	
}