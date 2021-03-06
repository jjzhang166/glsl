#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 p = gl_FragCoord.xy / resolution.xy - 0.5;
	float time = time * abs(sin(time/1000.0));
	p *= abs(sin(time/10.0)) * 50.0;
	float d = sin(pow(dot(p, p), 0.5))*sin(time);
	float g = atan(p.y, p.x);
	float a = sin(mod(g + time + sin(d+time), 3.1416/3.0)*3.1416);
	float v = a - d;
	float m = sin((dot(p,p)-sqrt(a))*4.0+time);
	gl_FragColor = vec4( -v*sin(m*g*2.+time/10.0), v*m*sin(tan(a)*g*6.+time/20.), mod(v,m), 1.0 );
}