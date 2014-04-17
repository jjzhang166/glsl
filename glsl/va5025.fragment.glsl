#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//one millionth shitty radar shader. yey.

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - vec2(0.5,0.5);
	position.y *= resolution.y/resolution.x;
	
	float color;
	
	float dist =sqrt(position.x*position.x+position.y*position.y);
	
	if(dist>0.3) {
		gl_FragColor = vec4(1.,1.,1.,1.);
	}
	if(dist>0.3025) {
		gl_FragColor = vec4(0.,0.,0.,1.);
	}
	if(dist<0.3) {
		color = pow(mod(-time/4.+(atan(position.y, position.x))/6.283,1.0),4.0);
		gl_FragColor = vec4(0.0,color,0.0,1.0);
	}
}