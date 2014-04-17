#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 n)
{
  return 0.5 + 0.5 *
     fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453);
}

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy );

	gl_FragColor.r = step(pos.x, rand(pos));
	gl_FragColor.g = 0.0;
	gl_FragColor.b = 0.0;
  	gl_FragColor.a = 1.0;max(pos.x, rand(pos));

}