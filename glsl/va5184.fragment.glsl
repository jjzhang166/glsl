#ifdef GL_ES
precision mediump float;
#endif

//tigrou (ind) 2012.08.30 (tigrou dot ind at gmail.com)
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

float wheel(vec2 p,float t)
{
	
  vec2 m = vec2(mod(p.x,2.0)-1.0, mod(p.y,2.0)-1.0);
  
  float a = pow(sin(t + 4.0 * atan(m.y,m.x)), 3.0);
  float e = 0.355 + min(a * 0.28, 2.26*(0.5+0.5*sin(time)));
  float d = length(m);
	
  return d < e && d > 0.3 ? 1.0 - abs(sin(t+1.0*atan(m.y,m.x)*1.0))*0.25  : 0.0;   
}


const float PI = 3.14159265;


vec2 complex_mul(vec2 factorA, vec2 factorB){
   return vec2( factorA.x*factorB.x - factorA.y*factorB.y, factorA.x*factorB.y + factorA.y*factorB.x);
}

vec2 torus_mirror(vec2 uv){
	return vec2(1.)-abs(fract(uv*.5)*2.-1.);
}

float sigmoid(float x) {
	return 2./(1. + exp2(-x)) - 1.;
}

float smoothcircle(vec2 uv, float radius, float sharpness){
	return 0.5 - sigmoid( ( length( (uv - 0.5)) - radius) * sharpness) * 0.5;
}


void main() {

	vec2 posScale = vec2(2.0);
	
	vec2 aspect = vec2(1.,resolution.y/resolution.x);
	vec2 uv = 0.5 + (gl_FragCoord.xy * vec2(1./resolution.x,1./resolution.y) - 0.5)*aspect;
	float mouseW = atan((mouse.y - 0.5)*aspect.y, (mouse.x - 0.5)*aspect.x);
	vec2 mousePolar = vec2(sin(mouseW), cos(mouseW));
	vec2 offset = (mouse - 0.5)*4.;
	offset =  - complex_mul(offset, mousePolar) +time*0.0;
	vec2 uv_distorted = uv;
	
	float filter = smoothcircle(uv_distorted, 0.15, 64.);
	uv_distorted = complex_mul(((uv_distorted - 0.5)*mix(1.2, 5.5, filter)), mousePolar) + offset;

	vec2 p = uv_distorted;
	//vec2 p = (gl_FragCoord.xy / min(resolution.x, resolution.y))-0.5;
        p *= 5.0;
	
        float t = sin(time)*10.0;
	
	float r = wheel(p, t)+wheel(p+vec2(1.0,1.0), t);
	float g = wheel(p+vec2(1.0,0.0),-t+PI/2.0);
        float b = wheel(p+vec2(0.0,1.0),-t-PI/2.0)+g;
	
	gl_FragColor = vec4(r,0,b, 1.0);
}
