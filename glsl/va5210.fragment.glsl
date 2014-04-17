#ifdef GL_ES
precision mediump float;
#endif
// mods by dist, shrunk slightly by @danbri, messed up by @zwa

precision mediump float;
uniform float time;
uniform vec2 mouse, resolution;
void main(void) {
	vec2 uPos = ( gl_FragCoord.xy / resolution.xy );//normalize wrt y axis
	uPos -= 0.5;
	vec3 color = vec3(0.0);
	float vertColor = 0.0;
	for( float i = 0.1; i < 15.0; i++ ) {
		uPos.y += cos( uPos.x*(i) + cos(time * i * 0.5) ) * 0.05;
		uPos.x += sin(time * i * 0.05) ;
		float fTemp = abs(0.9 / uPos.y / 150.0);
		vertColor += fTemp;
		color += vec3( fTemp*(10.0-i)/10.0, fTemp*i/30.0, pow(fTemp,0.9)*tan(.5) );
	}
	gl_FragColor = vec4(color, 0.0);
}