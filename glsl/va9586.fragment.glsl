#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 p = ( gl_FragCoord.xy / resolution.xy ) *4.-vec2(2.,2.);

	vec3 color = vec3(0);
	vec2 v = p;
	for (int i = 0; i <100; i++) {
		v = vec2(v.x*v.x-v.y*v.y,2.*v.x*v.y)+mouse*4.-2.;
		if (dot(v,v)>8.) {
			color = cos(float(i)/3.+vec3(0,2.,-2.))*.5+.5;
			break;
		}
	}

	color -= .15;
	v = p;
	for (int i = 0; i <100; i++) {
		v = vec2(v.x*v.x-v.y*v.y,2.*v.x*v.y)+p;
		if (dot(v,v)>8.) {
			color += .5;
			break;
		}
	}
	
	gl_FragColor = vec4( color, 1.0 );

}