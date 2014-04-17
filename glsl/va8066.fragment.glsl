#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//hexagon function by MrOMGWTF
//:)

float hexagon(vec2 p)
{
	vec2 ap = abs(p);
	ap.y = mod(ap.y + time + sin(time * 1.5), 1.5);
	ap.x = mod(ap.x + time - sin(time * 2.0), 1.5);

	if(ap.y < 0.89) if(ap.x < mix(1.0, 0.50, ap.y)) return 1.0;		
	return 0.0;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy * 2.0) -1.0;
	position *= pow(abs(sin(time)) + 0.2, 0.33);
	position.x *= resolution.x / resolution.y;
	position *= 2.0;
	
	gl_FragColor = vec4(hexagon(position) + ((position.y < 0.005 && position.y > -0.005) ? 1.0 : 0.0) - (length(position * 0.2)));
}