#ifdef GL_ES
precision mediump float;
#endif

// Some Atlanta Frag-o

uniform float time;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy;
	
	float MAX_DIST = resolution.x * resolution.x * cos( position.y ) * cos( position.y );

	float avg1 = 50.0 + sin( time * 10.0 ) * 0.5;
	float avg2 = 50.0 + tan( time * 2.0 ) * 0.5;
        float avg3 = 50.0 + acos( time * 4.0 ) * 0.5;
	
	avg1 = avg1 * sin( time * 2.0 ) * position.x * resolution.x;
        avg2 = avg2 * cos( time * 5.0 ) * position.y * resolution.x;
	avg3 = ( avg1 + avg2 ) * 2.0;
	
        float r = MAX_DIST / sqrt( ( position.x - avg1 ) * ( position.x - avg1 ) / ( position.y - avg3 ) * ( position.y - avg3 ) );
        float g = MAX_DIST / sqrt( mod( ( position.x - avg2 ) * ( position.x - avg2 ),( position.y - avg1 ) * ( position.y - avg1 ) ) );
        float b = MAX_DIST / sqrt( ( position.x - avg3 ) * ( position.x - avg3 ) / ( position.y - avg2 ) * ( position.y - avg2 ) );
	
	gl_FragColor = vec4( r, g, b, 1.0 );
}