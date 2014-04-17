#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float random( vec2 co )
{
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void )
{
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	float r1 = random(vec2(random(gl_FragCoord.xy)/time, random(gl_FragCoord.xy)/time));
	float r2 = random(vec2(random(gl_FragCoord.xy)/time, random(gl_FragCoord.xy)/time));
	
	float dist = distance(position.xy, vec2(r1, r2));
	gl_FragColor = vec4( vec3( dist, dist, dist ), 1.0 );
}