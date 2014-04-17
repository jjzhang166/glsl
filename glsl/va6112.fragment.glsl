#ifdef GL_ES
precision mediump float;
#endif

//dithering test

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 n)
{
  return fract(sin((n.x*1234265.0+n.y*115212.0)*0.001)*1e5);
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );

	gl_FragColor = vec4( vec3(  mix(0.0, 0.2, p.x) + rand(p) / 255.0 ), 1.0 );
}