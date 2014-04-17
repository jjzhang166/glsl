#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.14159265358979323;
const float TWOPI = 2.0*PI;

//loading loop by curiouschettai

void main( void ) {
	vec2 uPos = ( gl_FragCoord.xy / resolution.y );//normalize wrt y axis
	uPos -= vec2((resolution.x/resolution.y)/2.0, 0.5);//shift origin to center

	float angle = (atan(uPos.y, uPos.x)+PI)/TWOPI;
	float tone = 1.0 - fract(angle+time);
	
	float radius = sqrt(uPos.x*uPos.x + uPos.y*uPos.y);
	
	float smoothness = (0.002+(1.0-tone)/20.0);
	float innerRadius = 0.15+sin(angle*100.0)/100.0;
	float outerRadius = 0.3+sin(angle*100.0)/100.0;
	float a = smoothstep(outerRadius+smoothness, outerRadius-smoothness, radius * sin(time));
	float b = smoothstep(innerRadius+smoothness, innerRadius-smoothness, radius);
	
	float color = (a-b)*tone;
	gl_FragColor = vec4( color * sin(angle + sin(time)), color+ cos(radius * time), color - sin(.2 * radius * time), 1.0 );
}