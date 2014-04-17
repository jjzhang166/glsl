#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float pi = 3.14159265358979323846264;
	float pi2 = pi * 2.0;
	float n = 5.0;
	
	vec2 pos = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - vec2(1.0);
	pos *= vec2(resolution.x / resolution.y, 1.0);
	float ang = (atan(pos.y, pos.x) + pi);
	float ds = length(pos);
	ds *= (1.0 + sin(time * 2.3) * 0.2);
	vec4 bright = vec4(229.0 / 256.0, 86.0 / 256.0, 0.0, 1.0);
	vec4 dark = vec4(0.23, 0.3, 0.4, 1.0);
	ang += ds * 5.0 * cos(time);
	float tds = cos(pi / n) / cos(mod(ang, (2.0 * pi) / n) - pi / n);
	
	if(ds * 2.0 < tds) gl_FragColor = bright;
	else gl_FragColor = dark;

}