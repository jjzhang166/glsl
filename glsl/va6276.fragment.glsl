
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec3 color1 = vec3(0.7, 0.2, 0.2);

	vec3 color3 = vec3(0.25, 0.5, 0.5);
	
	vec2 point1 = resolution/2.0 + vec2(sin(time*2.0) * 150.0, cos(time*3.0) * 150.0);

	vec2 point3 = resolution/2.0 + vec2(sin(time)*2.0, sin(time*2.0)*5.0)*2.0;
	
	vec2 dist1 = gl_FragCoord.xy - point1;
	float intensity1 = pow(3.0/(0.01+length(dist1)), 2.0);
	
	vec2 dist3 = gl_FragCoord.xy - point3;
     	float intensity3 = pow(6.0/(0.01+length(dist3)), 7.0);
	

	gl_FragColor = vec4((color1*intensity1 + color3*intensity3)*mod(gl_FragCoord.x, 20.0)*mod(gl_FragCoord.y, 20.0),1.0);
}