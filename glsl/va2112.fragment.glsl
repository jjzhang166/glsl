//by @micgdev

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = ( ( gl_FragCoord.xy / resolution.xy ) * 5. ) - .8;
	
	p.y -= .5;
	
	float xw = pow(sqrt(abs(p.x)-0.5)*(1.-p.x*p.x), 0.01)-sqrt(cos(p.x))*cos(100.*p.x);
	
	gl_FragColor = vec4(xw - sin(time), xw - sin(time), xw - sin(time), 1.);
	
	if(p.y < xw){
		discard;
	}
	
}