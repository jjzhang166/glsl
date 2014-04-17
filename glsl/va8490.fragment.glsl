#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 posScale = vec2(resolution.y,resolution.x)/sqrt(resolution.x*resolution.y);
	vec2 position = (( gl_FragCoord.xy / resolution.xy ) );
	
	float sum = 0.;
	float qsum = 0.;
	
	for (float i = 0.; i < 100.; i++) {
		float x2 = i*i*.3165+(sin(time/10.)*i*0.01)+.5;
		float y2 = i*.161235+(cos(time/10.)*i*0.01)+.5;
		vec2 p = (fract(position-vec2(x2,y2))-vec2(.5))/posScale;
		float a = atan(p.y,p.x);
		float r = length(p)*100.;
		float e = exp(-r*.5);
		sum += sin(r+a+time)*e;
		qsum += e;
	}
	
	float color = sum/qsum;
	
	gl_FragColor = vec4(sin(color+time)*.5 + .5, cos(color+time)*.5 + .5, -sin(color+time) * .5 + .5, 1.0 );
}