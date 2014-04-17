#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float ev(float in_value) {
	return fract(in_value*40.0);
}



void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 lightpos = vec2(0.5, 0.5);
	
	float color = 0.0;
	vec2 norm  = position-lightpos;
	
	color += dot(position,norm)*dot(lightpos,norm);
	color += (norm.x*sin(time))-(norm.y*cos(time));
	color += ev(color)*0.1*step(color,0.2);
	

	gl_FragColor = vec4( color*0.5,color,color, 1.0);

}