#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

float calc(float f, vec2 uPos) {
	float t = time / 5.0;
	uPos.y += sin( t + uPos.x * 5.0) * 0.1;
	uPos.x += sin( t + uPos.y * 6.0) + 0.2;
	float value = sin((uPos.x) * 5.0) + sin(uPos.y * 4.0);
	return 1.0/sqrt(abs(value))/1.0 * pow(f, 10.);
}

void main( void ) {
	vec2 p = ( gl_FragCoord.xy / resolution.xy );		
	float vertColor = calc(p.y > .5 ? (.5 - (p.y - .5)) * 2. : p.y * 2., p) + 0.12345;
	gl_FragColor = vec4(vertColor, vertColor * sin(time / 4.0), vertColor * cos(time / 4.2), 0.);
}