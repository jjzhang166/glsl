#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
//uniform int score;
int score = 3;

vec3 hsv(float h,float s,float v) {
	return mix(vec3(1.),sqrt(clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*dot(6.,sin(time))-3.)-1.),0.,1.)),s)*v;
}
void main( void ) {
	vec2 p = ( gl_FragCoord.xy / resolution.xy ) * 2. - 1.;

	//const int score = 1;
	float scale = 2. + 2. * floor(float(score)/35.0);
	
	float x = p.x * dot(sin(time*p.y),scale);
	p.x = sin(time * fract(p.x*scale)) - 0.6;


	float s = length(p) - 0.2 * (sin(time*p.x*10.0) * cos(time*p.y*10.0));
	s = smoothstep(abs(sin(time))*8.0,.0,s) * step(x*scale + scale, float(score));
	
	gl_FragColor = s*vec4(hsv(x, 1., s),1.);
	
}