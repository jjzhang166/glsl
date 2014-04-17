#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float step1(float x0, float x) {
	if (x >= x0)
		return 1.0;
	else
		return 0.0;
}

void main( void ) {
	// from (-1.,-1.) to (1.,1.)
	vec2 p = ( gl_FragCoord.xy / resolution.xy )*2.0-1.0;
	float d; 
	vec4 col;
	
	// color gradients. black areas where p values are negative
	col = vec4( p.x, p.y, 0, 1.0 );
	
	// circular gradient centered in the middle
	// black to white towards outside
	d = length(p.xy);
	col = vec4(d, d, d, 1.0);
	
	d = step(0.2, 1.0-length(p.xy)); 
	col = vec4(d, d, d, 0.5);
	
	d = smoothstep(0.19,0.2,1.-length(p.xy)); 
	col = vec4(d, d, d, 1.0);
	
	gl_FragColor = col;
}