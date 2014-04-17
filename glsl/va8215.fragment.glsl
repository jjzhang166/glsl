#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// public domain
#define N 40
#define PI2 (3.14159265*2.0)
void main( void ) {
	
	vec2 p = vec2(gl_FragCoord.x/resolution.x, gl_FragCoord.y/resolution.y);
	vec2 v = (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 15.0;

	
	float t = time * 1.0;

	float factor = mouse.x * 1.0;
	float c = cos(mouse.y * PI2);
	float s = sin(mouse.y * PI2);
	
	
	for ( int i = 1; i <= N; i++ ){
		float d = float(i+3) / float(N);
		float x = v.x;
		float y = v.y + sin(v.x * d * 3.0 + t)/d*factor + cos(v.x * d + t)/d*factor;
		
		v.x = x * c - y * s;
		v.y = x * s + y * c;

	}
	float col = length(v)*0.25;
	
	col = col > 0.7 ? 1.0 : 0.0;

	
	vec4 fc = vec4( col, 0.0, 0.0, 1.0 );

	if(mouse.x > p.x || mouse.y > p.y){
		fc = vec4(col,1.0,0.0,1.0);	
	}
	

	gl_FragColor = fc;

}
