#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 n)
{
  return ((fract(n.x * (100.0/1.0))));
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = rand(position);
	gl_FragColor = vec4( color, color, color, 1.0 );

}