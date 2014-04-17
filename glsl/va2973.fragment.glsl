// @rotwang: @mod* scale with aspect, unipolar hue, radius change

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
	
	float ta = time/4.0;
	float usint = sin(time)*0.5+0.5;
	
	float aspect = resolution.x / resolution.y;
	vec2 unipos = gl_FragCoord.xy / resolution;
	vec2 p = unipos * 2. - 1.;
	
	float score = 2.0; // int(abs(sin(ta)*12.0));
	float scale = 4.0; 
	
	float x = unipos.x;
	p.x = fract(p.x*scale*aspect) - 0.5;
	
	p.y *= scale;

	float radius = 0.05 + 2.75*usint;
	radius *= unipos.x;
	float s = length(p) - radius;
	s = smoothstep(.015,.0,s);// * step(x*scale + scale, float(score));
	
	gl_FragColor = s*vec4(hsv(x, 1.0, 1.0),1.);
	
}