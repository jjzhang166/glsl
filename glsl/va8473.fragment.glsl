#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

        vec2 center = vec2(0.5, 0.5);
	vec2 pos = gl_FragCoord.xy / resolution.xy;
	float dis = 1.0 - distance(pos, center);
	dis = pow(dis, 15.0);
	dis += sin(dis*2.0 + time*4.0)*0.5 + 0.5;
	float r = sin(time + 2.0)*0.5 + 0.5;
	float g = sin(time + 4.0)*0.5 + 0.5;
	float b = sin(time + 6.0)*0.5 + 0.5;
	float th = atan(pos.y - center.y, pos.x - center.x) + time*1.0;
	th = mod(th, 3.14159*0.125);
	gl_FragColor = vec4(dis*r+th, dis*g+th, dis+th, 1);

}