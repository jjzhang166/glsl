#ifdef GL_ES
precision mediump float;
#endif

//Glitchy gameboy!
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 n)
{
  return 0.5 + 0.5 *
     fract(cos(dot(n.xy, vec2(12.999999992898, 1999978.233)))* 1111111.4145);
}

void main( void ) {

	//vec2 pos = ( gl_FragCoord.xy / resolution.xy );

	//gl_FragColor.r = step(pos.x, rand(pos));
	//gl_FragColor.g = 0.1;
	//gl_FragColor.b = 0.1;
  	//gl_FragColor.a = 1.0;max(pos.x, rand(pos));
  gl_FragColor.r = 1.0;

}