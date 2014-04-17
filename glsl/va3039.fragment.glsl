// Corrente Continua
// 1k demo by
// Zero the Hero of Topopiccione
//
// Final version / fixed horizontal and vertical breaks
// 11/Jul/2012

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float t = time * 3.0;
	vec2 p = (-1.0 + 2.0*(gl_FragCoord.xy /resolution.xy))*2.0*(1.0+sin(t/7.689)/2.5);
	vec2 p2 = p * 1.5;
	vec2 p3 = -p;
	float r = length(p); 
	float r2 = length(p2);
	p.x = tan( clamp((p.x-r/2.0*cos(t/4.0)+p.y/r), -1.4, 1.4));
	p.y = tan( clamp((p.y-r/1.5*sin(t/6.5)+p.x/r), -1.55, 1.4));
	p2.x = tan( -clamp((p2.x-r/2.5*cos(t/3.5)+p2.x/r), -1.4, 1.45));
	p2.y = tan( clamp((-p2.y-r2/1.3*sin(sqrt(t)/2.4)+p2.y/r), -1.4, 1.4));
	p3.x = tan( clamp((-p3.x-r2/2.5*cos(t/4.1313)-p2.x/r2), -1.45, 1.4));
	p3.y = tan( -clamp((p3.y-r/1.3*sin(t/3.414)+p3.y/r), -1.4, 1.4));
	
	// Domain repetition mods:
	// p.x = mod(p.x,3.3) + 0.5;
	// p3.y = mod(p3.y,3.8) + 0.5;
	
	float b = (3.0/(sin(p2.x) - cos(p2.y))) / 1.5;
	float a = (1.0/( sin(p.x) - cos(p.y) )) / 0.5;
	float c = (1.5/(cos(p.x) - sin(p2.y))) / 1.5;
	float d = (2.5/(cos(p.x) + sin(p2.y))) / 1.5 - (c/2.7);
	float f = (4.5/(cos(p3.x) + sin(p3.y))) / 1.5 + dot(b,a)/3.0;
	gl_FragColor = vec4(sqrt(2.0*a+b-c-d+f)/10.0-0.1,  sqrt(2.0*a+b-c-d+f)/10.0-0.1,  sqrt(1.8*a+b-c-d+f)/7.0-0.1,  1.0);
	}

