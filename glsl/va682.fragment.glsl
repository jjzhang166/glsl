#ifdef GL_ES
precision highp float;
#endif

//Glitchy gameboy!
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 n)
{
  return fract(cos(dot(n.xy, vec2(120.9949999992898, 1999978.233)))* 111111.4145);
}

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy ) ;
  	pos.y += cos(time * .0000015) + sin(time * .000015);

	gl_FragColor.r = step(pos.x, rand(pos));
	gl_FragColor.g = 0.0;
	gl_FragColor.b = 0.0;

}