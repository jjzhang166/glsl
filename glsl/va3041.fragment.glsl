#ifdef GL_ES
precision mediump float;
#endif

// that's probably how the higgs field looks like ;-)

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 posScale = vec2(resolution.y,resolution.x)/sqrt(resolution.x*resolution.y);
	vec2 position = (( gl_FragCoord.xy / resolution.xy ) );
	
	float sum = 0.0;
	float sum2 = 0.0;
	float qsum = 0.;
	float t = time * 0.07;
	
	for (float i = 0.; i < 100.; i++) {
		float x2 = i*i-.1165+(t*i*0.01)*0.5-.75;
		float y2 = i*i-.000161235+sin(t*i*0.03)*0.25+.5;
		vec2 p = (fract(position-vec2(x2,y2))-vec2(.5))/posScale;
		float a = atan(p.y,p.x);
		float r = length(p)*250.;
		float e = exp(-r*.8);
		
		float e2 = e*atan(r);
		sum += sin(r+a+time)*e2;
		sum2 += cos(r+a+time)*e2;
		qsum += e;
	}
	
	float color = sqrt(sum*sum)/qsum;
	
	gl_FragColor = vec4(color,color-.66,-color, 1.0 );
}