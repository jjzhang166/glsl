// Conway's Life Game. R-pentamino by Dima.. 
// mouse support
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec3 color;
vec2 pos;
float r;

bool at ( vec2 v ) {
	return ( pos.x > v.x - 0.5 && pos.x < v.x + 0.6 &&
	         pos.y > v.y - 0.5 && pos.y < v.y + 0.6 );
}

void main( void ) {

	pos = gl_FragCoord.xy;
	r = texture2D(backbuffer, vec2 ( 0.0 , 0.0 )).r;
	if ( pos.x < 1.0 && pos.y < 1.0 ) {
		if ( r > 0.9 ) 
			r = 0.0;
		else 
			r += 0.5;
		color.r = r;
	} else {
		if ( mod(time, 5000.0) < 1.0 ) {
			if ( at(vec2(200.0,  99.0) ) ||
			     at(vec2(200.0, 100.0) ) ||
			     at(vec2(200.0, 101.0) ) ||
			     at(vec2(199.0, 100.0) ) || 
			     at(vec2(201.0, 101.0) ))
				color = vec3 ( 1.0 );
		} else {
			if ( r == 0.0 ) {
				if ( distance ( pos, mouse * resolution ) < 0.8 )
					color = vec3 ( 1.0 );
				else {
				int k = 0;
				bool alive = texture2D ( backbuffer, pos / resolution ).g > .5;
				k += ( texture2D ( backbuffer, ( pos + vec2 ( -1., -1. ) ) / resolution ).g > .5 )?1:0;
				k += ( texture2D ( backbuffer, ( pos + vec2 ( -1.,  0. ) ) / resolution ).g > .5 )?1:0;
				k += ( texture2D ( backbuffer, ( pos + vec2 ( -1.,  1. ) ) / resolution ).g > .5 )?1:0;
				k += ( texture2D ( backbuffer, ( pos + vec2 (  0., -1. ) ) / resolution ).g > .5 )?1:0;
				k += ( texture2D ( backbuffer, ( pos + vec2 (  0.,  1. ) ) / resolution ).g > .5 )?1:0;
				k += ( texture2D ( backbuffer, ( pos + vec2 (  1., -1. ) ) / resolution ).g > .5 )?1:0;
				k += ( texture2D ( backbuffer, ( pos + vec2 (  1.,  0. ) ) / resolution ).g > .5 )?1:0;
				k += ( texture2D ( backbuffer, ( pos + vec2 (  1.,  1. ) ) / resolution ).g > .5 )?1:0;
				
				if ( alive ) 
					if ( k == 2 || k == 3 )
						color = vec3 ( 1.0 );
					else 
						color = vec3 ( 0.0 );
				else
					if ( k == 3 )
						color = vec3 ( 1.0 );
					else
						color = vec3 ( 0.0 );
				}
			} else 
				color = texture2D ( backbuffer, pos / resolution ).rgb;
		}
	}
	color.b = color.b * ( sin(time)*.5 + .5);
	gl_FragColor = vec4( color, 1.0 );

}