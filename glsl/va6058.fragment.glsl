#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(42.8763,78.233))) * 43758.5453);
}

float noise(vec2 pos)
{
	return mix(mix(rand(vec2(floor(pos.x), pos.y)), rand(vec2(ceil(pos.x), pos.y)), fract(pos.x)),
		   mix(rand(vec2(pos.x, floor(pos.y))), rand(vec2(pos.x, ceil(pos.y))), fract(pos.y)),
		   0.0);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	float color = 0.0;
	color = noise(position * 10.0);
	gl_FragColor = vec4( vec3( color), 1.0 );

}