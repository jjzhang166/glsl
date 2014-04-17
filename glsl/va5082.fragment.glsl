#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

struct Wave {
	float  radMul;
	float timeMul;
	float height;
	vec4 col;
	float powv;
};

void main( void ) {
	vec2 p = ( gl_FragCoord.xy / resolution.xy ) - vec2(0.5);
	p.x *= resolution.x/resolution.y;


	Wave wave[ 4 ];
	
	float h = 0.2;
	
	wave[ 0 ].radMul = 10.0;
	wave[ 0 ].timeMul = 1.0;
	wave[ 0 ].height = h;
	wave[ 0 ].col = vec4( 1,0,1,1 );
	wave[ 0 ].powv = 50.0;
	
	wave[ 1 ].radMul = 3.0;
	wave[ 1 ].timeMul = 4.0;
	wave[ 1 ].height = h;
	wave[ 1 ].col = vec4( 0.5,0,1,1 );
	wave[ 1 ].powv = 50.0;
	
	wave[ 2 ].radMul = -20.0;
	wave[ 2 ].timeMul = 9.0;
	wave[ 2 ].height = h;
	wave[ 2 ].col = vec4( 0.5,0,0.2,1 );
	wave[ 2 ].powv = 50.0;
	
	wave[ 3 ].radMul = 22.0;
	wave[ 3 ].timeMul = 6.0;
	wave[ 3 ].height = h;
	wave[ 3 ].col = vec4( 0.5,1,0.2,1 );
	wave[ 3 ].powv = 50.0;
	
	

	float rad = p.x;
	
	vec4 col = vec4( 0,0,0,1 );
	
	for( int i=0;i<4;i++ ){
		Wave w = wave[ i ];			      
			
		float sv = sin( rad*w.radMul +time*w.timeMul )*w.height;
		
		float dist = 1.0-length( vec2( p.x,p.y ) - vec2( p.x,sv ) );
		
		vec4 c = w.col * pow( dist,w.powv );
		
		col += c;
	}

	gl_FragColor = col;
	
}