#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 hsv(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}

void main( void ) {

	vec2 position = (gl_FragCoord.xy/resolution.y-vec2((resolution.x/resolution.y)/2.0,0.5))/1.0;
	float value = sin(1.0-distance(position,vec2(sin(atan(position.y, position.x)+time),sin(time+atan(time, position.y)-length(position))))*32.0+time*8.0)*.3+.3;
	
	gl_FragColor = vec4(hsv(value+position.x*position.y, 1.0, 1.0), 1.0 );

}