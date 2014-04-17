//Shader fun by harley 
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

float calc(float f, vec2 uPos) {
	float t = time / 4.1;
	
	uPos.y += cos( t + uPos.y * 0.1) * cos(0.1);
	uPos.x += uPos.y;	//uPos.x += cos( t + uPos.y * 6.0) * 1.1;
	float value = sin((uPos.x) * 11.0) + sin(uPos.y * 4.0);
	return 1.0/sqrt(abs(value))/2.0 * pow(f, 5.);
}

void main( void ) {
	vec2 p = ( gl_FragCoord.xy / resolution.xy );		
	float vertColor = calc(p.y > .5 ? (.5 - (p.y - .5)) * 2. : p.y * 2., p) + 0.0;
	gl_FragColor = vec4(vertColor, vertColor * sin(time / 4.0), vertColor * cos(time / 4.2), 0.);
}