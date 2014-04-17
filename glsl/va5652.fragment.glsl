#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

void main() {
	//vec2 p = (gl_FragCoord.xy / resolution - 0.5) * abs(sin(time/10.0)) * 50.0;
	//float d = sin(length(p)+time), a = sin(mod(atan(p.y, p.x) + time + sin(d+time), 3.1416/3.)*3.), v = a + d, m = sin(length(p)*4.0-a+time);
	//gl_FragColor = vec4(-v*sin(m*sin(-d)+time*.1), v*m*sin(tan(sin(-a))*sin(-a*3.)*3.+time*.5), mod(v,m),0);
	
	gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
}