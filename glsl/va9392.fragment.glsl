#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 r = vec2(resolution.x/resolution.y,1);
	vec2 p = ( gl_FragCoord.xy / resolution.y ) - r/2.;
	p *= 2.;

	vec3 n = normalize(vec3(p,sqrt(0.25-(p.x*p.x+p.y*p.y))));
	
	vec3 color = vec3(dot(n,vec3(cos(time),cos(time)*sin(time),sin(time))));

	gl_FragColor = vec4( color, 1.0 );

}