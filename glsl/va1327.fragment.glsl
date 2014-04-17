//MyVoronoi
//created by nikoclass

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


const int N = 50;

vec3 rand3 (float x) {
	return fract(vec3(sin(x * 2661.581) * 6183.57, sin(x * 6135.164) * 587.62, sin(x * 4815.164) * 9816.62));	
}


void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	vec3 color = vec3(1.0);
	
	int minI = 0;
	float minDist = 1000.0;
	float minDist2 = 1000.0;
		
	for (int i = 0; i < N; i++) {
		vec2 p = rand3(float(i)).xy;
		
		float m = 0.2 - clamp(distance(mouse, p), 0.0, 0.2);
		p += 2.0*m*(p - mouse);
		
		float d = distance (p, position);
		if (d < minDist) {
			minDist = d;
			minI = i;
		}
		else if (d < minDist2){
			minDist2 = d;
		}
				
	}
	
	if (abs(minDist - minDist2) < 0.005) {
		gl_FragColor = vec4(0.1);
	}
	else {
		gl_FragColor = vec4(rand3(float(minI * 10)), 1.0 );	
	}
	
}