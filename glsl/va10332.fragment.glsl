#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

float lin(float x){
	return (x+1.0)*0.5;
}

float cs(float x){
	return lin(cos(x));
}

float sq(float x){
	return x*x;
}

float f(float x,float r,float o){
	return 1.0/(1.0 + r*sq(x-o));
}

float noise(vec3 pos) {
	return sin(22.0*pos.x) + sin(29.0*pos.y) + sin(30.*pos.z);
}

vec3 v1 = vec3(1.,2.,3.);
vec3 v2 = vec3(1.2,-3.,2.1);
vec3 v3 = vec3(-2.2,-9.,0.7);

void main()
{
	
	float R = 0.25;	
	
	vec2 pos = (gl_FragCoord.xy / resolution.xy) ;	
	vec2 p = pos - mouse;
	vec3 r = vec3(p,sqrt(R*R-dot(p,p)));
	
	float phi = time*0.99;
	
	float c = cos(phi);
	float s = sin(phi);
	
	r = vec3(r.x*c-r.z*s , r.y , r.x*s+r.z*c);		
	
	
	vec4 color = vec4(dot(r,v1), dot(r,v2),  dot(r,v3) , 0.0);
	vec4 stencil = vec4(length(p)<R ? 1.0 : 0.0,length(p)<R ? 1.0 : 0.0 ,length(p)<R ? 1.0 : 0.0 ,0.0);
		
	
	
	gl_FragColor = color * stencil;
}
