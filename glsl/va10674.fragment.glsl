#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float col;

void line ( vec2 a, vec2 b ) {
	vec2 pos = gl_FragCoord.xy / resolution;
	float d = distance ( pos , mouse );
	float dl = distance ( pos , a ) + distance ( pos , b ) - distance ( b , a );
	col += max ( 1.0 - pow ( dl , 0.01 + d*(0.2 + sin ( time * 15.0 ) * 0.01 ) ) , 0.0 );
}

void main( void ) {

	line ( vec2 ( .13 , .8 ) , vec2 ( .26 , .2 ) );
	line ( vec2 ( .13 , .2 ) , vec2 ( .26 , .8 ) );
	
	line ( vec2 ( .32 , .8 ) , vec2 ( .42 , .5 ) );
	line ( vec2 ( .37 , .2 ) , vec2 ( .47 , .8 ) );
	
	line ( vec2 ( .55 , .8 ) , vec2 ( .75 , .8 ) );
	line ( vec2 ( .75 , .2 ) , vec2 ( .55 , .2 ) );
	line ( vec2 ( .55 , .8 ) , vec2 ( .55 , .2 ) );
	line ( vec2 ( .75 , .2 ) , vec2 ( .75 , .8 ) );
	line ( vec2 ( .55 , .2 ) , vec2 ( .75 , .8 ) );
	
	
	
	
	gl_FragColor = vec4 ( vec3 ( col  ) , 0.0 );
}