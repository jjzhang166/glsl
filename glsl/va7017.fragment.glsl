#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// a raymarching experiment by kabuto
//fork by tigrou ind (2013.01.22)
//optimized
// turned into neon tubes in fog by psonice
// more color and distorsion by @hintz

const int MAXITER = 30;

vec3 field(vec3 p)
{
	p = fract(p)-.5;
	p *= p;

	return sqrt(p+p.zxy)-.05;
}

void main(void) 
{
	vec3 dir = normalize(vec3((gl_FragCoord.xy-resolution*.5)/resolution.x,1.));
	float a = time * 0.1;
	dir *= mat3(cos(a),0,-sin(a),0,1,0,sin(a),0,cos(a));
	vec3 pos = dir; //vec3(0.0,time*0.1,0.0);
	dir *= mat3(1,0,0,0,cos(a),-sin(a),0,sin(a),cos(a));
	
	vec3 color = vec3(0);
	float e = 1.0;
	float es = e*0.5/float(MAXITER);
	vec3 f2;
	float f;
	for (int i = 0; i < MAXITER; i++) 
	{
		f2 = field(pos);
		f = min(min(f2.x,f2.y),f2.z);
		pos += dir*f;
		e -= es*f;
		color += f2*e*abs(dir)-f;
	}
	
//	color -= 16.0*f2*e;
	
	gl_FragColor.rgb = color/4.0;
}