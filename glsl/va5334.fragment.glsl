#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// A simple starfield renderer by Kabuto. It reduces the amount of work by splitting the screen into pie pieces and limiting itself to just the stars that lie within.
// See http://glsl.heroku.com/e#5334.3 for a version with a not-so-realistic but different look that's also much faster.

void main( void ) {

	vec2 position = ( gl_FragCoord.xy -  resolution.xy*.5 ) / resolution.x;

	// 256 angle steps
	float angle = atan(position.y,position.x)/(2.*3.14159265359);
	angle -= floor(angle);
	float rad = length(position);
	
	float color = 0.0;
	for (int i = 0; i < 100; i++) {
		float angleFract = fract(angle*32.);
		float angleRnd = floor(angle*32.)+1.;
		float angleRnd1 = fract(angleRnd*fract(angleRnd*.7235)*45.1);
		float angleRnd2 = fract(angleRnd*fract(angleRnd*.82657)*13.724);
		float t = time+angleRnd1*10.;
		float radDist = sqrt(angleRnd2+float(i)+2.);
		
		float adist = radDist/rad*.1;
		float dist = (t*.1+adist);
		dist = abs(fract(dist)-.5);
		float xdist = dist*5./adist;
		float ydist = abs(angleFract-.5);
		
		
		color += max(0.,.5-(xdist*xdist+ydist*ydist)*(adist*adist*radDist*radDist)*20.)*5.;
		
		angle = fract(angle+.61);
	}

	gl_FragColor = vec4( color )*.3;

}