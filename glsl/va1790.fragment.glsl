#ifdef GL_ES
precision highp float;
#endif

uniform float time;
//uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
vec2 pp = (-1.0 + 2.0 * gl_FragCoord.xy / resolution.xy);
	vec2 p = vec2(pp.x, pp.y*resolution.y/resolution.x);
	
float sx = sign(p.x);
float sy = sign(p.y);
float sd = sign(distance(p, vec2(0.0,0.0))-0.5);
	
float c = mod(p.x * sx  +p.y *sy -time/10.0 *sd, 0.1) >0.05 ? cos(time): sin(time);
	float cc = mod(p.y * sx  +p.x *sy -time/14.0 *sd, 0.1) >0.05 ? cos(time): sin(time);
gl_FragColor = vec4(pp.x * sin(time) - cc + cos(time  *  pp.x),c + cc * sin(pp.x) -  cos(time) * pp.y,c * sin(time) * 0.5 + 0.5,.0);
}