#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 n)
{
  return 0.5 +
     fract(sin(dot(n.xy, vec2(resolution.x * 0.1, 0)))/ 40.0)  * fract(sin(dot(n.xy, vec2(0,resolution.y* 0.1)))/ 40.0);
}

float random(vec2 co){
    return fract(sin(dot(co.xy,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	float color = random(position);
	gl_FragColor = vec4( color, color, color, 1.0 );

}