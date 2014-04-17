#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec2 rand1(vec2 pos)
{
	return fract( pow(pos+2.0+fract(time), pos.yx+2.0 )*22222.0 );
}

vec2 rand(vec2 pos)
{
	return rand1( rand1 (rand1(pos)));
}

void main( void )
{
	vec2 position = gl_FragCoord.xy / resolution.xy;
	int c[9];
	if( mouse.x == 0.0 ) {
		float rand = rand(position)[0];
		if ( rand > 0.5 ) {
			gl_FragColor = vec4( 1.0, 1.0, 1.0, 1.0 );
		} else {
			gl_FragColor = vec4( 0.0, 0.0, 0.0, 1.0 );
		}
	}else{
		c[0] = int( texture2D(backbuffer, (gl_FragCoord.xy+vec2(-1.0,-1.0)) / resolution.xy) );
		c[1] = int( texture2D(backbuffer, (gl_FragCoord.xy+vec2( 0.0,-1.0)) / resolution.xy) );
		c[2] = int( texture2D(backbuffer, (gl_FragCoord.xy+vec2( 1.0,-1.0)) / resolution.xy) );
		c[3] = int( texture2D(backbuffer, (gl_FragCoord.xy+vec2(-1.0, 0.0)) / resolution.xy) );
		c[4] = int( texture2D(backbuffer, (gl_FragCoord.xy+vec2( 0.0, 0.0)) / resolution.xy) );
		c[5] = int( texture2D(backbuffer, (gl_FragCoord.xy+vec2( 1.0, 0.0)) / resolution.xy) );
		c[6] = int( texture2D(backbuffer, (gl_FragCoord.xy+vec2(-1.0, 1.0)) / resolution.xy) );
		c[7] = int( texture2D(backbuffer, (gl_FragCoord.xy+vec2( 0.0, 1.0)) / resolution.xy) );
		c[8] = int( texture2D(backbuffer, (gl_FragCoord.xy+vec2( 1.0, 1.0)) / resolution.xy) );
		int num = c[0] + c[1] + c[2] + c[3] + c[5] + c[6] + c[7] + c[8];
		if( num==3 || ( num==2 && c[4]==1 ) ) {
			gl_FragColor = vec4( 1.0, 1.0, 1.0, 1.0 );
		}else{
			gl_FragColor = vec4( 0.0, 0.0, 0.0, 1.0 );
		}
	}
}