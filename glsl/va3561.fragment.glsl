#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// HSV to RGB conversion.

// h - hue in degrees [0.0 - 360.0]
// s - saturation     [0.0 - 1.0]
// v - value          [0.0 - 1.0]
vec4 hsvToRgb(float h, float s, float v) {
	float r, g, b;

	float c = v * s;
	float i = h / 60.;
	float x = c * (1. - abs(mod(i, 2.) - 1.0));
	float m = v - c;

	int q = int(mod(i, 6.));
	     if (q==0) { r=c ; g=x ; b=0.; }
	else if (q==1) { r=x ; g=c ; b=0.; }
	else if (q==2) { r=0.; g=c ; b=x ; }
	else if (q==3) { r=0.; g=x ; b=c ; }
	else if (q==4) { r=x ; g=0.; b=c ; }
	else           { r=c ; g=0.; b=x ; }

	r+=m;
	g+=m;
	b+=m;
	return vec4(r, g, b, 1.0);
}

void main( void ) {
	float h = mod(time * 30., 360.);
	float s = mix(0.2, 0.8,
//		      (cos(gl_FragCoord.x / 10. + time) + 1.) / (2. + sin(time))
		      gl_FragCoord.x/resolution.x
		      );
	float v = mix(0.2, 0.8,
//		      (sin(gl_FragCoord.y / 10. + time) + 1.) / (2. + cos(time))
		      gl_FragCoord.y/resolution.y
		     );

	float x = gl_FragCoord.x - resolution.x/2.;
	float y = gl_FragCoord.y - resolution.y/2.;
	float r = sqrt(x*x+y*y);
	float a = atan(y,x);
	
	float maxr = min(resolution.x/3., resolution.y/3.);
	if (r > maxr) {
		h = a/6.2831853 * 360.;
		s = r / maxr - 1.;
		v = mix(0.8, 1.0, (sin(time)+1.)/2.);
	}
	
	vec4 color = hsvToRgb(h, s, v);
	gl_FragColor.rgb = color.rgb;
}