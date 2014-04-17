#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 center = resolution/2.;
	
	float intensity = pow(32. / length(center - gl_FragCoord.xy), 4.);
	
	intensity += pow(32. * (pow(exp(-abs(gl_FragCoord.x - center.x) * 0.01), 2.)) / abs(resolution.y / 2. - gl_FragCoord.y), .5);
	intensity += pow(intensity, 2.0);
	gl_FragColor = vec4(vec3(.1, .5, .7) * intensity * 0.8, 1.);
}