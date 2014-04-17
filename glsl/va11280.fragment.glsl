#ifdef GL_ES
precision mediump float;
#endif

// Bewb physics

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void)
{
	vec2 p = (2.0*gl_FragCoord.xy-resolution.xy)/resolution.y;
	p.y -= 0.25;
	
	// background color
	vec3 bcol = vec3(0.0,0.0,1.0-0.05*p.y)*(1.0-0.25*length(p));
	
	
	// animate
	float tt = mod(time,0.5)/1.0;
	float ss = pow(tt,0.2)*0.5 + 0.6;
	ss -= ss*0.2*sin(tt*30.0)*exp(-tt*4.0);
	p *= vec2(0.5,1.5) + ss*vec2(0.5,-0.5);
   

	// shape
	float a = atan(p.x,p.y)/3.141593;
	float r = length(p);
	float h = abs(a);
	float d = (12.0*h - 23.0*h*h + 11.15*h*h*h)/(7.0-5.0*h);

	// color
	float s = 1.0-0.5*clamp(r/d,0.0,1.0);
	s = 0.75 + 0.75*p.x;
	s *= 1.0-0.25*r;
	s = 0.5 + 0.6*s;
	s *= 0.5+0.5*pow( 1.0-clamp(r/d, 0.0, 1.0 ), 0.1 );
	vec3 hcol = vec3(0.40,0.55*r,0.65)*s;
	
	vec3 col = mix( bcol, hcol, smoothstep( -0.04, 0.04, d-r) );

	gl_FragColor = vec4(col,1.0);
}