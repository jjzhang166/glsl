// Let's see how many particles can be rendered simultaneously...
// another dirty hack from psonice :)

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D bb;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float o = length(position - .5 + vec2(cos(time*.34*4.), sin(time*.55*4.))*.5);
	//o = o < 0.01 ? 1. : 0.;
	o = clamp(1.-o*50., 0., 1.);
	
	vec4 b = texture2D(bb, position);
	vec4 f = vec4(b.a * 25. + o, b.r / 25., b.g, b.b)*1.;
	gl_FragColor = f;

}