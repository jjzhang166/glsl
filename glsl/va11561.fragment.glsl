#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float gain(float g, float t) {
	float n = step( 0.5, t );
	float p = (1.0 / g - 2.0) * (1.0 - 2.0 * t);
	return (1.0 - n) * t / (p + 1.0) + n * (p - t) / (p - 1.0);
}

float boxstep(float a, float b, float t) {
    return clamp( (t - a) / (b - a), 0.0, 1.0 );
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	position.x = 0.5 + (position.x - 0.5) * resolution.x / resolution.y;
	
	float d = distance(vec2(0.5,0.5),position)/0.5;
	
	d += mouse.y;
	
	float m = gain(mouse.x, boxstep(0.85, 1.0, d));
	
	if (m == 0.0 || m == 1.0) discard;
	
	float n = gain( mouse.y, position.y );
	
	gl_FragColor = vec4( mix( vec3(0.0,1.0,0.0), vec3(1.0,0.0,1.0), m ), 1.0 );
}