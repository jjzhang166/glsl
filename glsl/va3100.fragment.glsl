// @rotwang:
// The impossible lattice (2012)
// variation D-13x209-n some nice colored rects

#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


vec3 hsv2rgb(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}

vec3 shade(float x)
{
	x*=16.0 ;
	float a = sin(x) * sign(cos(x))+1.0;
	a += 14.0 + 14.0*sin(time*0.5);
	a /= 32.0;
	
	float b = cos(x+1.57) * sign(sin(x+1.57))+1.0;
	b*=0.5;
	float c =  mix(a,b,0.8);
	return hsv2rgb(a,b,c);
}




void main()
{
	float aspect = resolution.x /resolution.y;
	vec2 unipos = ( gl_FragCoord.xy / resolution );

	vec3 clr_a = shade(unipos.x);
	vec3 clr_b = shade(unipos.y);
	
	vec3 rgb = min(clr_a, clr_b);
	
	gl_FragColor = vec4(rgb, 1.0);
}