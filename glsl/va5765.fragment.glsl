#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

float rand(vec2 co){
	if(gl_FragCoord.x > (resolution.x*.5)) {
		return fract(sin(dot(mod(co.xy, 256.) ,vec2(12.9898,78.233))) * 1e5);
	} else {
		return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
	}
}
void main( void ) {

	vec2 p = gl_FragCoord.xy / resolution.xy;

	vec3 col =vec3( step(rand(p), p.y));
	gl_FragColor = vec4( col, 1.0 );
}