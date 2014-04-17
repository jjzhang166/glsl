#ifdef GL_ES
precision mediump float;
#endif

// that's probably how the higgs field looks like ;-)

//another one of my shader screwing up sessions :P
//now it looks like EVIL GOOP!!! or something...
//@scratchisthebes

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 posScale = vec2(resolution.y,resolution.x)/sqrt(resolution.x*resolution.y);
	vec2 position = (( gl_FragCoord.xy / resolution.xy ) );
	
	float sum = 0.1;
	float sum2 = 0.0;
	float qsum = 0.;
	float t = time * 0.9;
	
	for (float i = 0.; i < 20.; i++) {
		float x2 = i*i-(t/5.)+(t*i*0.01)*0.5;
		float y2 = i*i-.5+sin(t*i*0.03)*0.5001;
		vec2 p = (fract(position-vec2(x2,y2))-vec2(.5))/posScale;
		float a = atan(p.y,p.x);
		float r = length(p)*20.;
		float e = exp(-r*0.8);
		
		float e2 = e*atan(r);
		sum += sin(r+a+time)*e2;
		sum2 += cos(r+a+time)*e2;
		qsum += e;
	}
	
	float color = sqrt(sum*sum)/qsum;
	
	gl_FragColor = vec4(color,color+0.1,color+0.2, 0.1 );
}