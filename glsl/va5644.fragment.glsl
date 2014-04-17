// By Paul Jacobs - codehearted.com

//Derived from code by Ángel Linares García. www.blurrypaths.com
// My Changes -- made multiple "flare points" and sped up pulsing, made it more pronounced.

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy;
	float color;
	
	vec2 lightpos = mouse*resolution;
	
	vec2 norm = lightpos - position;
	float sdist = pow((norm.x * norm.x),1.0/3.0) + pow((norm.y * norm.y),1.0/3.0);
	
	vec3 light_color = vec3(1.2,0.8,0.6);
	
	color =  (1.0 / (sdist * (min(abs(.3-mouse.x),abs(0.7-mouse.x)))))*cos(0.9*(sin(time*1.2)));
	gl_FragColor = vec4(color,color,color,1.0)*vec4(light_color,1.0);

}