#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 center = resolution/2.;
		
	vec2 _mouse = mouse * resolution;
	float radius = 8. + (10. *sin(time));
	float shiny = 2. ; // ~ 0.1-9.9
	
	shiny += 3. * abs(cos(time));
	
	float intensity = pow(radius/length((_mouse) - gl_FragCoord.xy), shiny);
	
	intensity += pow((2.*radius) * (pow(exp(-abs(gl_FragCoord.x - _mouse.x) * 0.0005), 194.)) / (0.5 + abs(_mouse.y  - gl_FragCoord.y)), shiny);
	
	float red = (220. + (35. * cos(time)));
	float green = red - 85.;
	float blue = green - 85.; 
	
	gl_FragColor = vec4(vec3(red/255., green/255., blue/255.) * intensity, 1.);
	
}