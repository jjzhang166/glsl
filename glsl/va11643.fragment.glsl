//Stare at the dot for 30 seconds then look away

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float itime = floor(time*50.);
	float x = 0.;
	for (float k = 0.; k < 16.; k++) {
		x = 0.5*sqrt(1.+8.*(floor(mod(gl_FragCoord.x-gl_FragCoord.y+itime, 16.0))+16.0*k))-0.5;
		if (distance(x, floor(x)) < 0.001) break;
	}
	gl_FragColor = vec4(x/32.0);
	if (distance(gl_FragCoord.xy, resolution/2.)<2.0)gl_FragColor = vec4(1,0,0,1);
}