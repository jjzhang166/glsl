#ifdef GL_ES
precision mediump float;
#endif
// dashxdr was here 20120228
 
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
 
	vec2 position = ( 2.0*gl_FragCoord.xy - resolution) / resolution.xx;
 
	float adjust1 = mouse.x * 100.0;
	float adjust2 = mouse.y;
	position *= adjust1;
	float r = length(position);
	float fix = -time*5.0;
	vec2 p = vec2(r*cos(r+fix), r*sin(r+fix));
	float dd = length(position - p);
	dd = fract(dd*adjust2);
	dd *= 4.0 * (1.0 - dd);
	gl_FragColor.rgba = vec4(dd,dd,dd, 1.0);
 
}
