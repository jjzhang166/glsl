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
float supershape(vec2 p, float m, float n1, float n2, float n3, float a, float b, float s, float r) {
	float ang = atan(p.y * resolution.y, p.x * resolution.x) + r;
	float v = pow(pow(abs(cos(m * ang / 4.0) / a), n2) + pow(abs(sin(m * ang / 4.0) / b), n3), -1.0 / n1);
	return 1. - step(v * s * resolution.y, length(p * resolution)); 
}

void main( void ) {
	vec2 p = (gl_FragCoord.xy / resolution) * 2.0 - 1.0;
	p *= 2.5;
	
	vec4 color;
		
	color += supershape(p - vec2(-2, 1), 6.0, 1.0, 7.0, 8.0, 1.0, 1.0, 0.12, sin(time));
	color += supershape(p - vec2(-2, -1), 3.0, 4.5, 10.0, 10.0, 1.0, 1.0, 0.45, sin(time*.9));
	color += supershape(p - vec2(-1, 1), 7.0, 10.0, 6.0, 6.0, 1.0, 1.0, 0.65, sin(time*.95));
	color += supershape(p - vec2(-1, -1), 16.0, 0.5, 0.5, 16.0, 1.0, 1.0, 0.55, sin(time*.7));
	color += supershape(p - vec2(0, 1), 4.0, 12.0, 15.0, 15.0, 1.0, 1.0, 0.55, sin(time*.82));
	color += supershape(p - vec2(0, -1), 19.0, 9.0, 14.0, 11.0, 1.0, 1.0, 0.6, sin(time*.88));
	color += supershape(p - vec2(1, 1), 6.0, 60.0, 55.0, 1000.0, 1.0, 1.0, 0.32, sin(time*.75));
	color += supershape(p - vec2(1, -1), 6.0, 0.53, 1.69, 0.45, 1.0, 1.0, 0.9, sin(time*1.2));
	color += supershape(p - vec2(2, 1), 8.0, 0.5, 0.5, 0.3, 1.0, 1.0, 1.15, sin(time*1.1));
	color += supershape(p - vec2(2, -1), 6.0, -0.62, 30.0, 0.6, 1.0, 1.0, 0.75, sin(time*1.05));

	gl_FragColor = vec4(color);
	gl_FragColor.r += smoothstep(.0,.7,p.y * p.x + p.x * p.x * cos(time) * cos(p.x + p.y) );
	gl_FragColor.g /= (sin(time*p.y));
	gl_FragColor.b *= (p.y+(abs(time)));

}
