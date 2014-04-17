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
	//forked for animation. -gt.
	vec3 col =vec3( step(rand(p+time), p.y+(tan(time*1.5)*.5-.5)+sin(time*64.)*.25-.5));
	gl_FragColor = vec4( vec3(col.r*cos(time*4.)*2.,col.r*sin(time*32.)*.25,col.r*sin(time*64.)), 1.0 );
}