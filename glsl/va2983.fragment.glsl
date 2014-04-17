/*
Supershapes!
Use 0.5
by xpansive
*/

// @rotwang: @mod+ single centered supershape
// radial hsv coloring
// outer zone darkened 
// normalized supershape

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 hsv2rgb(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}

// @rotwang: normalized version
// s is for scale, r is for rotation
float supershape(vec2 p, float m, float n1, float n2, float n3, float a, float b, float s, float r) {
	

	float ang = atan(p.y , p.x ) + r;
	float v = pow(pow(abs(cos(m * ang / 4.0) / a), n2) + pow(abs(sin(m * ang / 4.0) / b), n3), -1.0 / n1);
	return 1. - step(v * s , length(p ));
}

void main( void ) {
	
	float aspect = resolution.x / resolution.y;
	vec2 unipos = gl_FragCoord.xy / resolution;
	vec2 bipos = unipos * 2.0 - 1.0;
 	bipos.x *=aspect;
	
    	float radius = length(bipos);
	
	float hue = 1.2 - radius*0.5;
	float lum = 1.0 - length( bipos)*0.5;
	vec3 rgb = hsv2rgb(hue,1.0, lum);
	
	
	rgb *= supershape(bipos, 5.0,
			  0.33, 0.73, 0.73,
			  1.0, 1.0, 1.0,
			  sin(time*0.33)*4.0);
	
	
	gl_FragColor = vec4(rgb, 1.0);
}
