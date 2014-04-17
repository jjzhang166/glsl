#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D bb;

void main( void ) {

	vec2 center = vec2(0,0);
	
	center.x += mouse.x*resolution.x;
	center.y += mouse.y*resolution.y*2.;
	
	float intensity = 0.001;
	
	intensity += pow(32. * (pow(exp(-abs(gl_FragCoord.x - center.x) * 0.01), 2.)) / abs(center.y / 2. - gl_FragCoord.y), .5);
	intensity += pow(intensity, 2.0);
	gl_FragColor = vec4(vec3(.7, .3, .1) * intensity * 0.8, 10.) + texture2D(bb, gl_FragCoord.xy / resolution) * .9;
}