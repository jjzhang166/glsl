/*

Supershapes!
Use 0.5

by xpansive

*/

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// s is for scale, r is for rotation
vec4 supershape(vec2 p, float m, float n1, float n2, float n3, float a, float b, float s, float r) {
	float ang = atan(p.y, p.x) + r;
	float v = pow(pow(abs(cos(m * ang / 4.0) / a), n2) + pow(abs(sin(m * ang / 4.0) / b), n3), -1.0 / n1);
	return vec4(length(p*sin(v-sin(time*1.23)))* step(v * s,length(p)),(length(p) - sin(v * s * 2.)),1. - (length(sin(p)) - v * s),0.); 
}

void main( void ) {
	vec2 p = (gl_FragCoord.xy / resolution.x) * 2.0 - 1.0;
	p *= 4.5;
	
	vec4 color;
		
	color += supershape(p + vec2(0, 2), 6.0, sin(time*.9)*5.0+6., 7.0, 10.0, 1.0, 1.0, 0.3, sin(time));
	
	
	gl_FragColor = vec4(color);
}
