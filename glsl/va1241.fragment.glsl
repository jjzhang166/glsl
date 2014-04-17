#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
    	uniform vec2 resolution;

    	void main( void ) {

        vec2 position = - 10.0 * gl_FragCoord.xy / resolution.xy;
        float green = abs( tan( position.x * position.x + time / 1.0 ) );
        float blue = abs( sin( position.y * position.x + time / 1.0 ) );
        float red = abs( sin( position.y * position.y + time / 1.0 ) );
	gl_FragColor = vec4( red, green, blue, 1.0 );

    	}
