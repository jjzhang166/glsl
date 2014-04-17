#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 center = resolution/2.;
	
	float intensity = pow(8. / length(center - gl_FragCoord.xy), 4.);
	
	intensity += pow(8. * (pow(exp(-abs(gl_FragCoord.x - center.x) * 0.0005), 64.)) / abs(resolution.y / 2. - gl_FragCoord.y), 2.);
	
	gl_FragColor = vec4(vec3(200./255., 142./255., 71./255.) * .5 + vec3(200./255., 142./255., 71./255.) * intensity, 1.);;
}