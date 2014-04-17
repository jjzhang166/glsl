#ifdef GL_ES
precision highp float;
#endif

//Glitchy gameboy!
//Your turn. - uitham

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 n)
{
  return fract(cos(dot(n.xy, vec2(120.9949999992898, 1999978.233)))* 111111.4145);
}

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy ) ;
  	pos.y += atan(time * .5) / 14.0 + atan(time * .5) / 14.0;
        pos.x += cos(time * .5) / 14.0 + cos(time * .5) / 14.0;

	gl_FragColor.r = step(pos.x, rand(pos));
	gl_FragColor.g = 0.0;
	gl_FragColor.b = 0.0;

}