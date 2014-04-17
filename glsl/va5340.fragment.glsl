#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy -  resolution.xy*.5 ) / resolution.x;

	// 256 angle steps
	float angle = atan(position.y,position.x)/(2.*3.14159265359);
	angle -= floor(angle);
	float rad = length(position);
	
	float color = 0.0;
	float color1 = 0.0;
	float color2 = 0.0;
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
		
		
		color += max(0.002,.5-(xdist*xdist+ydist*ydist)*(adist*adist*radDist*radDist)*120.)*1.9;
		color1 += max(0.0,10.5-(xdist*xdist+ydist*ydist)*(adist*adist*radDist*radDist)*10.)*0.05;
		color2 += max(0.05,11.5-(xdist*xdist+ydist*ydist)*(adist*adist*radDist*radDist)*110.)*0.07;		
		angle = fract(angle+.61);
	}

	gl_FragColor = vec4( color, color1, color2, 1.0 )*.3;

}