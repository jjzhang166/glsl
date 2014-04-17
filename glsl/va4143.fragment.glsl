#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float nrand( vec2 n ) {
  return fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453);
}


void main( void )
{
	vec2 pos = ( gl_FragCoord.xy );
	float rnd = nrand( gl_FragCoord.xy*0.01 + 0.001*time );
	gl_FragColor = vec4( vec3(rnd), 1.0 );
}
