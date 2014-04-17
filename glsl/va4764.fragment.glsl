#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.1416
//@fernozzle

void main( void ) {
	const float r = 0.5;
	vec2 p = (-1.0 + 2.0 * ((gl_FragCoord.xy) / resolution.xy));
	p.x *= (resolution.x / resolution.y);
	float dist = length(p);
	float ang = atan(p.y,p.x);
	float offs = sin(ang*5. + time *1.)*0.1;
	dist += offs;
	float shade = (max(0., min((r-dist)*60., 1.0)) - 1.0) * -.3*pow(min(1.0, abs((ang+PI*0.5)*0.7)), 10.);
	if(dist < r)
		gl_FragColor = vec4((vec3(1.0, 0.95, 0.8)+offs) + shade, 1.0 );
	else{
		float dist = distance(p, vec2(0., -0.1));
		float ang = atan(p.y,p.x);
		float offs = sin(ang*5. + time *1.)*0.1;
		dist += offs;
		dist = dist * 5. - 1.5;
		dist = max(0.7, min(dist, 1.));
		gl_FragColor = vec4(vec3(0.2) * dist, 1.0);
	}

}