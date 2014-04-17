#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265358979323

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float Prec(float n, float p) {
	return(float(int(n*p))/p);	
}

vec3 Tunnel(vec2 p) {
	float an = mod(atan(p.y, p.x)/PI, 2.);
	float d = .6/length(p) + time;
	float bd = -step(mod(d, .4), .2) + step(mod(d, .8), .4);
	float v = min(bd, step(mod(Prec(an, (sin(time/2.)+1.5)*10.)+d-time, 1.), 0.5))*.8/(d-time);
	return vec3((sin(time+an*PI)+1.)/2.*v, (sin(time+an*PI+2./3.*PI)+1.)/2.*v, (sin(time+an*PI+4./3.*PI)+1.)/2.*v);
}

void main( void ) {
	vec2 p = ((gl_FragCoord.xy) / resolution.y) + mouse.xy-.5;
	p.y -= 0.5;
	p.x -= resolution.x/resolution.y*0.5;
	
	gl_FragColor = vec4(Tunnel(p), 1.);
}