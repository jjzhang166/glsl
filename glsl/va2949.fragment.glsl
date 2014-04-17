#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

void main( void ) {
	float itt = 0.0 ;
	vec2 f = gl_FragCoord.xy / resolution.xy * 2.9 - 0.5 - surfacePosition - mouse, pos, c, z, n;
	pos = f;
	z = f;;
	c.x = 0.285 * (cos(time)*0.5 + 1.6);
	c.y = 0.01 * (sin(time)*0.5 + 2.0);
	
	for(int i = 0 ; i < 50 ; i ++ ){
		n.x = z.x * z.x - z.y * z.y + c.x;
		n.y = z.y * z.x + z.x * z.y + c.y;
		
		if(length(n) > 16.0)
			break;
		z = n;
		
		itt += 1.0;
	}

	gl_FragColor = vec4( 1.0) * (itt / 50.0);

}