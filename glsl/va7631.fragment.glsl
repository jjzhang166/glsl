#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
uniform vec2 surfaceSize;
varying vec2 surfacePosition;

vec2 pos;
vec3 color;
float r, angle;
void main( void ) {
	color = vec3(0.0);
	pos = (gl_FragCoord.xy - resolution.xy/2.0)/resolution.xx;
	pos = (pos + surfacePosition)*surfaceSize.xx;
	r = length(pos);
	angle = atan(pos.y, pos.x);
	color += vec3(1.0, 1.1, 1.3) * r + cos(time+7.0*angle) * sin(time);
	pos.x += sin(time+angle) * 3.0;
	pos.y += cos(time+angle) * 3.0;
	r = length(pos);
	color += fract(vec3(1.0, 1.1, 1.3) * r + cos(time+7.0*angle) * sin(time));
	gl_FragColor = vec4(0.5 * ( 1.0 + sin(color) ),1.0);
}