#ifdef GL_ES
precision mediump float;
#endif

uniform float time; 
uniform vec2 mouse;
uniform vec2 resolution;

// a raymarching experiment by kabuto
//fork by tigrou ind (2013.01.22)
//optimized
//slow mod by mkjpboffi.tumblr.com
//fly mod by @jimhejl

#define MAXITER 110
#define MAXITER_SQR MAXITER*MAXITER

vec3 field(vec3 p) {
	p = abs(fract(p)-.5);
	p *= p;
	return sqrt(p+p.yzx*p.zzy)-.015;
}


vec3 lerp(vec3 a, vec3 b, float i)
{
    return ((a*(1.0-i)) + (b*i));
}

vec3 filmic(vec3 x)
{
    x=max(vec3(0.0),x-vec3(0.004));
    x=(x*(vec3(6.2)*x+vec3(0.5)))/(x*(vec3(6.2)*x+vec3(1.7))+vec3(0.06));
    return pow(x,vec3(2.2)); // sRGB
}

void main( void ) 
{
	vec3 dir = normalize(vec3((gl_FragCoord.xy-resolution*.5)/resolution.x,1.));
	float a = time * 0.25;
	vec3 pos = vec3(sin(a),cos(a)*0.1,mod(time,-12.0));
	vec3 color = vec3(0);
	for (int i = 0; i < MAXITER; i++) {
		vec3 f2 = field(pos);
		vec3 rep = vec3(2);
		float f = min(min(min(f2.x,f2.y),f2.z), length(mod(pos-vec3( 0.3,1.0-0.3,0.0),rep)-0.5*rep)-0.15);
		pos += dir*f;
		color += (float(MAXITER-i)/(f2+1e-5));
	}
	vec3 color3 = vec3(-1./(1.+color*(.3/float(MAXITER_SQR))));
	color3 = color3*color3;
	float intensity = dot(color3,vec3(1));
	color3 = intensity * lerp(vec3(0.7,0.75,1.0),vec3(1.11,1.0,0.8)*2.5,intensity);
	gl_FragColor = vec4(filmic(color3.rgb*1.5),1.);
}