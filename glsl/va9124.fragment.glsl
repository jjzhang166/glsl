#ifdef GL_ES
precision mediump float;
#endif
 
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
 
/* public domain */

vec3 rgbFromHue(float h) {
	
	const float K= 1.0/6.0;
	h = h - floor(h);
	
	float r = smoothstep( 2.0*K, 1.3*K, h) + smoothstep( 4.0*K, 5.0*K, h);
	float g = smoothstep( 0.0*K, 1.0*K, h) - smoothstep( 3.0*K, 4.0*K, h);
	float b = smoothstep( 2.0*K, 3.0*K, h) - smoothstep( 5.0*K, 6.0*K, h);
	
	return vec3(r,g,b);
}

#define N 100
void main( void ) {
	vec2 v = (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 2.0;
 
	vec2 shift = vec2( 
		(mouse.x)*0.15+0.3, 
		(mouse.y)*0.15+0.3);
	float zoom = 1.0;
	for ( int i = 0; i < N; i++ ){
		v = vec2(v.x*v.x-v.y*v.y, 2.0*v.x*v.y);
		float rr = v.x*v.x-v.y*v.y;

		if ( rr > 2.0 ){
			float c = float(i)/float(N);
			gl_FragColor = vec4( rgbFromHue(c), 1.0 );
			return;
		}
		v = v * zoom + shift;
	}
	gl_FragColor = vec4( 0.0,0.0,0.0, 1.0 );
 
}