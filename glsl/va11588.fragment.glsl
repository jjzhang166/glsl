#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float fn(float x) {
	return 2.*atan((x-0.5)*40.)/3.1416;
}
void main( void ) {
	float x=1.0;
	for (int i=0; i<5; i++) {
		vec2 circ,a,v;
		a=vec2(rand(vec2(.5*float(i+1),.0)),rand(vec2(.6*float(i+1),.0)));
		v=vec2(rand(vec2(.7*float(i+1),.0)),rand(vec2(.8*float(i+1),.0)));
		circ=resolution*(0.7*a*vec2(sin(time+v.x*10.),sin(time+v.y*10.))+vec2(1.,1.))/vec2(2.,2.);
		
		x *= distance(gl_FragCoord.xy, circ)/100.;
	}
	x=1.-fn(x);
	gl_FragColor = vec4( x,x,x, 1.0 );
}