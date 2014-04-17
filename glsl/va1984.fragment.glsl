#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 hsv(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}
void main( void ) {
	vec2 p = ( gl_FragCoord.xy / resolution.xy ) * 2. - 1.;

	int score = int(abs(sin(time))*60.);
	float scale = 10. + 10. * floor(float(score)/20.);
	
	float x = p.x;
	p.x = fract(p.x*scale) - 0.5;
	p.y += .9;
	p.y *= scale;

	float s = length(p) - 0.4;
	s = smoothstep(.15,.0,s) * step(x*scale + scale, float(score));
	
	gl_FragColor = s*vec4(hsv(x, 1., s),1.);
	
}