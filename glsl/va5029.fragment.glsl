#ifdef GL_ES
precision mediump float;
#endif

//CITIRAL WAS HERE
//JUST DOING THIS FOR BEER

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const int lines = 4;
const float speed = 0.4;
const float width = 0.04;
const float height = 0.5;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	p.x *= resolution.x/resolution.y;
	
	gl_FragColor = vec4(sin(time),cos(time),cos(sin(time)),0) * 0.4;
	
	for (int i = 0 ; i < lines ; i++){
		
		float sinus;
		sinus = ((sin((time * float(i+1) * speed) + p.x) + 1. ) * 0.5 * height) + ((1.-height)/2.);
		
		if (p.y > sinus -width && p.y < sinus + width) {
			gl_FragColor = vec4(abs(sin(time+float(i)*0.4)),abs(cos(time+float(i)*0.4)),abs(sin(cos(time+float(i)*0.4))),0);
		}
		
	}

}