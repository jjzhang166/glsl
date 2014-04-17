#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Move the mouse pointer around the screen to wreak havoc in this newton fractal. 

void main( void ) {

	vec2 p = ( gl_FragCoord.xy - resolution.xy*.5 )*5./resolution.x;

	vec2 a = (mouse-.5)*3.+vec2(1.,0);
	
	for (int i = 0; i < 50; i++) {
		float l = dot(p,p);
		vec2 d = p*1./3.-vec2(p.x*p.x-p.y*p.y,-2.*p.x*p.y)/(3.*l*l);
		p -= vec2(d.x*a.x-d.y*a.y,d.x*a.y+d.y*a.x);
	}

	float angle = atan(p.y,p.x);
	float amp = atan(length(p))*2./3.14159265359;
	
	vec3 color = vec3(cos(angle),cos(angle+2.1),cos(angle-2.1));
	
	
	gl_FragColor = vec4(vec3(amp)+color*amp*(1.-amp),1.);

}