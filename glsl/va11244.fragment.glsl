#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.1415926

void main( void ) {

	
	vec2 p = gl_FragCoord.xy / resolution.y;
	p.y -= 0.5;
	p.x -= 0.5*resolution.x/resolution.y;
	
	float an = atan(p.y, p.x);
	/*an = mod(an, PI);*/
	float dy = 1.0/(distance(p, vec2(0., 0.)))*((sin(time/2.)+1.02)*3.) + 2.*an;
	
	gl_FragColor = vec4( vec3(cos(time*10.0+dy)*50.0)+0.5,1.0 );

}