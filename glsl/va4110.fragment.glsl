#ifdef GL_ES
precision mediump float;
#endif

//something gorgeous
//add things, fork it

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 position;

float map(in float x)
{
	return (x + 1.0) * 0.5;	
}

float wave(float freq, float offset)
{
	return map(sin(position.x * 6.28 * freq + offset));	
}

void main( void ) {

	position = ( gl_FragCoord.xy / resolution.xy );
	
	float depth = wave(64.0, time) + wave(4.0, -time * 1.0) + wave(32.0, time * 4.0);
	
	depth /= 3.0;
	
	depth = pow(depth, 1.0/0.3);
	
	depth = clamp(depth, 0.0, 1.0);
	
	depth = pow(depth, 0.5);
	
	depth = clamp(depth, 0.0, 1.0);
	
	depth += 0.189;
	
	vec3 final = vec3(depth);
	
	final *= pow(position.y, 1.3);
	final = pow(final, vec3(1.4, 0.8 + (pow(1.0 - position.y, 1.0)), 1.1));

	gl_FragColor = vec4( final, 1.0 );

}