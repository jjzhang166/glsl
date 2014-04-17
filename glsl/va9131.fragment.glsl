#ifdef GL_ES
precision mediump float;
#endif
 
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
 
/* public domain */
 
#define N 40
void main( void ) {
	vec2 v = (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 2.0;
 
	vec2 shift = vec2( 
		(mouse.x-.5)*4.0 + .1*cos(time*.1), 
		(mouse.y-.5)*4.0 + .01*sin(time*.1) );
	float zoom = 2.0;
	float thick = 0.30;
	for ( int i = 0; i < N; i++ ){
		v = vec2(v.x*v.x-v.y*v.y, 2.0*v.x*v.y);
		float rr = v.x*v.x+v.y*v.y;
		if ( rr > 1.0 ){
			rr = 5.0/rr;
			v.x = v.x * rr;
			v.y = v.y * rr;
		}
		if ( rr > 1.0-thick ){
			float c = float(i)/float(N)*10.0;
			vec3 color = vec3(cos(c*1.0), cos(c*2.0), cos(c*4.0))*.5+.5;
			float shade = 1.0-(1.0-rr)/thick;
			gl_FragColor = vec4( color*shade, 1.0 );
			return;
		}
		v = v * zoom + shift;
	}
	gl_FragColor = vec4( 0.0,0.0,0.0, 1.0 );
 
}