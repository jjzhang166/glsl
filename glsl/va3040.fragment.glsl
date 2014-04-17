// Corrente Continua
// 1k demo by
// Zero the Hero of Topopiccione
//
// Final version / fixed horizontal and vertical breaks
// 11/Jul/2012


// @rotwang @mod* nice source to play with ;-)

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float t = time * 2.0;
	float sint = sin(time*0.25);
	vec2 p = (-1.0 + 2.0*(gl_FragCoord.xy /resolution.xy))*2.0*(1.0+sin(t/7.689)/3.5);
	vec2 p2 = abs(p * -2.5);
	vec2 p3 =p*p;
	
	float r = p.x*2.0; 
	float r2 = fract(length(p2));
	p.x = tan( clamp((p.x-r/2.0*cos(t/0.0)+p.y/r), -0.4, 0.4));
	p.y = tan( clamp((p.y-r/1.5*sin(t/0.5)+p.x/r), -0.55, 0.1));
	p2.x *= p.x *tan( -clamp((p2.x-r/0.5*cos(t/3.5)+p2.x/r), -0.4, 0.45));
	p2.y *= p.x * tan( clamp((-p2.y-r2/1.3*sin(sqrt(t)/2.4)+p2.y/r), -2.4, 0.3));
	p3.x =  atan( clamp((-p3.x-r2/0.5*cos(t/2.1313)-p2.x/r2), -0.45, 0.3));
	p3.y =  atan( -clamp((p3.y-r/0.3*sin(t/1.414)+p3.y/r), -0.4, 0.4));
	
	// Domain repetition mods:
	 p2.x -= mod(p3.x,3.3) + 0.5;
	 p2.y -= mod(p3.y,3.3) + 0.5;
	
	float b = (3.0/(sin(p2.x) - cos(p2.y))) / 1.5;
	float a = (1.0/( sin(p.x) - cos(p.y) )) / 0.5;
	float c = (1.5/(cos(p.x) - sin(p2.y))) / 1.5;
	float d = (2.5/(cos(p.x) + sin(p2.y))) / 1.5 - (c/2.7);
	float f = (1.5/(cos(p3.x) + sin(p3.y))) / 1.5 + dot(b,a)/3.0;
	gl_FragColor = vec4(sqrt(2.0*a+b-c-d+f)/12.0-0.1,  sqrt(2.0*a+b-c-d+f)/10.0-0.1,  sqrt(1.8*a+b-c-d+f)/9.0-0.1,  1.0);
	}

