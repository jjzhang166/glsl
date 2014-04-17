// Original By @paulofalcao
//
// Blobs with nice gradient

#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
uniform vec2 resolution;

float makePoint4(vec4 x, vec4 y, vec4 fx, vec4 fy, vec4 sx, vec4 sy, vec4 r, vec4 t) {
   vec4 xx = sin(t*fx)*sx - x;
   vec4 yy = cos(t*fy)*sy - y;

	
	vec4 a = r / (xx*xx+yy*yy);
	return dot( a, vec4(1.0) );
}


void main( void ) {

   vec2 p = (gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);
	p *= 3.0;

	float a = 0.0;
	a += makePoint4( p.xxxx, p.yyyy, vec4( 3.5, 2.1, 1.0, 2.7 ), vec4( 2.9, 2.0, 0.7, 0.1 ), vec4( 0.3, 0.4, 0.4, 0.6 ), vec4( 0.3, 0.4, 0.5, 0.3 ), vec4( 2.7, 1.0, 0.4, 0.7 ), vec4(time) );
	a += makePoint4( p.xxxx, p.yyyy, vec4( 1.0, 3.1, 1.1, 1.1 ), vec4( 1.7, 0.4, 1.4, 1.7 ), vec4( 0.5, 0.6, 0.5, 0.4) , vec4( 0.4, 0.3, 0.5, 0.4 ), vec4( 1.0, 2.0, 3.0, 2.2 ), vec4(time) );
		
	a /= 170.0;
	a *= a; // ^2
	a *= a; // ^4
	a *= a; // ^16
	
	a += step( abs( fract( 0.001*time*resolution.x)*resolution.x - gl_FragCoord.x ), 1.0 );
	
   gl_FragColor = vec4( vec3(a), 1.0);
}