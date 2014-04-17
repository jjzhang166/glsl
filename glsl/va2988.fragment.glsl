// @rotwang

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 hsv2rgb(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}

void main( void ) {
	float t = time/8.0;
	
	float aspect = resolution.x / resolution.y;
	vec2 unipos = gl_FragCoord.xy/resolution;
	vec2 bipos = unipos*2.0-1.0;
	bipos.x *= aspect;
	
	vec2 center = vec2(0,0);
	float ta = sin(t/4.0)*32.0;
	float tb = cos(t/16.0)*4.0;
	float a = sin(2.0-distance(bipos,center)*ta);
	float b = cos(distance(bipos,center)*tb);
	
	vec3 rgb = hsv2rgb(a,b,a);
	gl_FragColor = vec4(rgb, 1.0 );

}