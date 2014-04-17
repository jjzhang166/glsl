#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 n)
{
  return 0.5 +  0.1*
     (fract(n.y));
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 reso = vec2(1,1);
	float color = rand(position/reso);
	gl_FragColor = vec4( color, color, color, 1.0 );

}