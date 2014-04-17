// Corona(2012) by rotwang

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const float PI = 3.1415926535;
const float TWOPI = PI*2.0;

float speed = time *0.5;

vec3 hsv2rgb(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}

// implementation found at: lumina.sourceforge.net/Tutorials/Noise.html
float rand(vec2 co){
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

// corona by rotwang
float corona(vec2 p)
{

	float k = length( p) * time * 0.0000005;
	
	float rd = pow(rand(p+k),1.0/8.0);
	float len =  length( p) * rd;
	
	float shade = 1.0-smoothstep(0.25, 0.75, len);
	return shade;
}

vec3 corona_clr(vec2 p)
{
	float g = length(p)* 0.2;
	float m = 0.15; 
 	float hue = min( m, g);
	
	
 	float sat = corona(p)* (1.2-length(p));
 	float lum = corona(p);
	lum *= 1.33-length(p);
	
	
	return hsv2rgb(hue,sat, lum);
}

void main( void ) {
	
	float aspect = resolution.x / resolution.y;
	vec2 unipos = gl_FragCoord.xy / resolution;
	vec2 pos = unipos*2.0-1.0;
	pos.x *= aspect;
	
	vec3 clr = corona_clr(pos);
	gl_FragColor = vec4(clr,1.0);

}