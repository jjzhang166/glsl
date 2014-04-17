#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float mandelbrot(vec2 p, vec2 n) {
	float iter = 0.;
	vec2 d = vec2(1.,0.);
	for(int i=0; i<5; i++) {
		d = vec2(d.x*p.x-d.y*p.y,d.x*p.y+d.y*p.x)*2.;
		p = vec2(p.x*p.x-p.y*p.y,2.*p.x*p.y)+n;
		iter++;
	}	
	return length(d)/length(p);
}



void main( void ) {


	vec2 n = (gl_FragCoord.xy-resolution*.5)/resolution.y*2.;
	vec2 p = n;
	
	
	float c = 0.;
	
	vec2 m1 = mouse*4.-2.;
	vec2 m2 = vec2(cos(time)*1.5-1.,sin(time)*1.5);
	
	
	float stp = fract(dot(fract(sin(time+gl_FragCoord.xy)*100.),vec2(3.,4.)));
	
	
	for(int i=0; i<31; i++) 	{
		c += mandelbrot(n,(m1*(1.-stp)+m2*stp)/31.);
		stp++;
	}
	c *= .3;

	gl_FragColor = vec4( vec3( c*.01, c*.003, c*.001 ), 1.0 );

}