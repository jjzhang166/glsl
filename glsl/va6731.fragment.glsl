#ifdef GL_ES
precision mediump float;
#endif
// mods by dist, shrunk slightly by @danbri

precision mediump float;
uniform float time;
uniform vec2 mouse, resolution;
void main(void) {
	vec2 uPos = ( gl_FragCoord.xy / resolution.xy );//normalize wrt y axis
	uPos -= .2; //orientation vert
	vec3 color = vec3(0.0);
	float vertColor = 0.0;
	for( float i = 0.7; i < 4.0; ++i ) { //no. of lines
		uPos.y += sin( uPos.x*(i) + (time/5.5 * i * i * 0.1) ) * 0.4; // i * n = speed / * n = wave height
		float fTemp = abs(0.5 / uPos.y / 50.0);
		vertColor += fTemp;
		color += vec3( fTemp*(4.0-i)/7.0, fTemp*i/20.0, pow(fTemp,7.0)*0.5 );
	}
	gl_FragColor = vec4(color, 10.0);
}