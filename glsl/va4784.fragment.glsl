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
	for( float i = 0.; i < 50.; ++i ) {
		uPos.x -= sin( -uPos.y*(i) + (time * i * i * 0.05) ) * 0.0006;
		float fTemp = abs(2.0 / uPos.x / 3600.0);
		vertColor -= fTemp;
		color += vec3( fTemp*(20.0-i)/20.0, fTemp*i/1000.0, pow(fTemp,1.9)*0.9 );
	}
	gl_FragColor = vec4(color, 1.0);
}