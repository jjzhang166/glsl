#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void )
{
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) ;
  
	float f = (1.0+sin(position.x*3.14*10.0+time))/2.0+(1.0+cos(position.y*3.14*10.0+time/2.0))/2.0;	
	

	gl_FragColor = vec4( f*position.x, f*position.y, f*position.x*position.y, 1.0);

}