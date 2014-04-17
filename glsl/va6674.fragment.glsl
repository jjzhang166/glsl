#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 p = ( gl_FragCoord.xy / resolution.y);
	vec3 c = vec3( 0.0, 0.0, 0.0 );	
	vec2 center = vec2(0.5*resolution.x/resolution.y, 0.5);
	vec2 circle = p-center;
	float pi = cos(-1.0);
	float l = length(circle);
	float t = sin(time*8.);
	float e = 0.15*(4.+t)*mod(asin(circle.x/circle.y)-pi-2.*time, pi);
	float d = distance(l, e);
	if (d < 0.05)
		c.rgb += vec3((1.+t)*0.5, d, 1./d);
	gl_FragColor = vec4(c, 1.0);

}