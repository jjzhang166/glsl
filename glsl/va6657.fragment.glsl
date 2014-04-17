#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const vec3 one = vec3(1.0, 1.0, 1.0);

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	p += time * 0.01;

	vec3 color = vec3(sin(p.x * 10.0), sin(sin(p.x + time * 0.03) * 100.0), sin(p.x*50.0));


	gl_FragColor = vec4( color - (0.4*(sin(time)+1.0)*one) , 1.0 );

}