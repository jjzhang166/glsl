#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// random [0;1]
float rand(vec2 n)
{
  return fract(sin(dot(n.xy, vec2(1., 1e3))*1e-3)* 1e6);
}

void main( void ) {

	vec2 position = gl_FragCoord.xy - floor(mouse*resolution);

	float color = rand( position.xy );

	gl_FragColor = vec4( color, color, color, 1 );

}