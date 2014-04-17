#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 n)
{
	
  return 
     fract(sin(dot(n.xy, vec2(time*12.9898, 78.233)))* 43758.5453);
}

void main( void ) {

	float aspect = resolution.x / resolution.y;
	vec2 unipos = ( gl_FragCoord.xy / resolution.xy );
	vec2 pos = unipos*2.0-1.0;
	pos.x *= aspect;
	
	float color = rand(pos) * length(pos);
	gl_FragColor = vec4( color, color, color, 0.6 );

}