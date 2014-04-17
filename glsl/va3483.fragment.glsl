#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// kabuto: lots of fields blended together. White spots indicate their centers and intensities.

void main( void ) {

	vec2 position = ( (gl_FragCoord.xy - resolution.xy*0.5) / resolution.x );
	vec2 mouse2 = (mouse - .5) * resolution / resolution.x;
	float size = 100.;
	vec2 color = vec2(0.);
	float color2 = 0.;
	vec2 cp = vec2(sin(time), sin(time*0.535))*0.3;
	vec2 cp2 = vec2(cos(time), cos(time*0.535))*0.3;
	for (float i = 0.; i < 1.; i+=.01){
		// compute center
		vec2 center0 = cp*(1.-i)+cp2*i;
		vec2 center1 = cp*(1.-i)*(1.-i)+cp2*i*i;
		center1 += (2.*mouse2-center0)*2.*i*(1.-i);
		
		// compute intensity
		float f = i*(1.-i)*(.5-i)*(.5-i)*50.;
		
		// blend
		float d = distance(position, center1)*size;
		color += vec2(cos(d),sin(d))*f;
		color2 += 1./(d*d)*f;
	}
	color *= .1;
	vec2 ncolor = normalize(color);
	
	gl_FragColor = vec4(ncolor.x*.5+.5,ncolor.y*.5+.5,-ncolor.x*.25-ncolor.y*.25+.5, 1.0 )*sqrt(color.x*color.x+color.y*color.y)*.33+color2/100.;

}