#ifdef GL_ES
precision mediump float;
#endif

//Colourful flower by curiouschettai

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 uPos = gl_FragCoord.xy/resolution.y;
	uPos += vec2(-resolution.x/resolution.y/2.0, -0.5);
	
	float fragRadius = sqrt(uPos.x*uPos.x + uPos.y*uPos.y);

	float sin1Radius = 0.2 + 0.13*sin(time)*sin(2.0*time+atan(uPos.y, uPos.x)*10.0);
	float xVal1 = (fragRadius-sin1Radius);
	float sin1Contrib = sin(20.0*abs(xVal1)+time);
	
	float sin2Radius = 0.4 + 0.03*sin(time*2.0)*sin(-2.0*time+atan(uPos.y, uPos.x)*10.0);
	float xVal2 = (fragRadius-sin2Radius);
	float sin2Contrib = sin(10.0*abs(xVal2)+30.0-time);
	
	float sin3Radius = 0.4 + 0.07*sin(time+80.0)*sin(time+atan(uPos.y, uPos.x)*10.0);
	float xVal3 = (fragRadius-sin3Radius);
	float sin3Contrib = sin(10.0*abs(xVal3)+50.0-2.0*time);	

	gl_FragColor = vec4(sin1Contrib, sin2Contrib, sin3Contrib, 1.0);
}