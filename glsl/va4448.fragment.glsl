#ifdef GL_ES
precision mediump float;
#endif
// mods by dist, shrunk slightly by @danbri

precision mediump float;
uniform float time;
uniform vec2 mouse, resolution;
void main(void) {
	vec2 uPos = ( gl_FragCoord.xy / resolution.xy );//normalize wrt y axis
	uPos -= .5;
	vec3 color = vec3(0.0);
	float vertColor = 0.0;
	for( float i = 0.; i < 9.; ++i ) {
		uPos.y += sin( uPos.x*(i*3.0) + (time * 1.9)   +i/0.2 ) * i*0.015;
		float fTemp = abs(1.0 / uPos.y / 80.0);
		vertColor += fTemp;
		color += vec3( fTemp*(10.0-i)/10.0-fTemp/3.0, fTemp*i/10.0, pow(fTemp,0.99)*0.3 );
	}
	gl_FragColor = vec4(color, 1.0);
}