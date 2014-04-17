#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 frctl(vec2 a){
	float d = a.x*a.x + a.y*a.y;
	float l = 1.0-pow(d,0.1);
	float t = (sin(a.x/d+time*2.0)*sin(a.y/d))*sqrt(d)*0.025;
	float t2 = (sin(a.x/d)*sin(a.y/d+time*2.0))*sqrt(d)*0.05;
	return vec3(l+t+t2*1.8,l+t-t2,l-t*5.0);
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xx );
	vec3 color = frctl(position-mouse*resolution/resolution.xx);

	gl_FragColor = vec4(color, 1.0 );
}
