#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy ) * 2. ;
        float color = 0.0;

	if ( pos.y > .5 - sin(pos.x * 8. +time)/2. ) { 
          color = .9;
	}

		if ( pos.x >  sin(time)) { 
//	color = .92;
	}

	
	gl_FragColor = vec4( vec3( color / sin(cos(time) + cos( pos.y * pos.x)), .01+sin(time * pos.y + pos.x) *  color, 2. *  color * sin(time * pos.y * pos.x)), 1.0 );

}