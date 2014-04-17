#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//hexagon function by MrOMGWTF
//:)

float hexagonDist(vec2 p)
{
	vec2 ap = abs(p);
	return max(ap.y - 0.89, ap.x - mix(1.0, 0.5, ap.y));
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy * 2.0) -1.0;
	position *= pow(abs(sin(time)) + 0.2, 0.33);
	position.x *= resolution.x / resolution.y;
	position *= 3.0;
	float d = hexagonDist(position);
	gl_FragColor = vec4((sin(d * 10.0)) < 0.05);
}