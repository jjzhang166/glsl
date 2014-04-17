#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

float rand(vec2 co){
		return fract(sin(dot(mod(co.xy, 256.)+vec2(time*0.011,time*0.0011) ,vec2(12.9898,78.233))) * 1e5);
}
void main( void ) {

	vec2 p = gl_FragCoord.xy / resolution.xy;

	vec3 col =vec3( step(rand(p), 1.0-3.0*length(p.xy-vec2(0.5,0.5))));
	gl_FragColor = vec4( col, 1.0 );
}