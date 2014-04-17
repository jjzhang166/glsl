#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy -  resolution.xy*.5001 ) / resolution.x;

	// 256 angle steps
	float angle = atan(position.y,position.x)/(2.*3.14159265359);
	float rad = length(position);
	
	// added "black hole" (formula not really realistic, though)
	const float bhsize = .13;
	rad /= bhsize;
	float frad = sign(rad-1.);
	rad = tan(atan(rad)-1./sqrt(rad-1.));
	rad = rad*bhsize;
	
	
	angle += .25*sign(rad);
	rad = abs(rad);
	angle -= floor(angle);

	float color = 0.0;
	for (int i = 0; i < 100; i++) {
		float angleFract = fract(angle*256.);
		float angleRnd = floor(angle*256.)+1.;
		float angleRnd1 = fract(angleRnd*fract(angleRnd*.7235)*45.1);
		float angleRnd2 = fract(angleRnd*fract(angleRnd*.82657)*13.724);
		float t = time+angleRnd1*10.;
		float radDist = sqrt(angleRnd2+float(i));
		
		float adist = radDist/rad*.1;
		float dist = (t*.1+adist);
		dist = abs(fract(dist)-.5);
		color += max(0.,.5-dist*40./adist)*(.5-abs(angleFract-.5))*5./adist/radDist;
		
		angle = fract(angle+.61);
	}

	gl_FragColor = vec4( sqrt(color*sqrt(rad)+.0055/sqrt(.01+rad)) )*.3*(frad+1.)*.5;

}