#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float box ( vec3 pos, vec3 size )
{
	vec3 b = abs ( pos - size ) - size;
	return max ( b.x, max ( b.y, b.z ) );
}

void main( void )
{

	vec3 position = vec3 ( gl_FragCoord.xy / resolution.xy, 0.15 );

	gl_FragColor = vec4 ( box ( position, vec3 ( 0.001 ) ) );

}