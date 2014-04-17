#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float sdSphere( vec3 p, float s )
{
  return length(p)-s;
}
void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) ;
		
	vec3 pos = vec3(position.x,position.y,2.);
	
	float dist = sdSphere(pos,1.0);
	
	if( dist>0.)
	    gl_FragColor = vec4( vec3(1.,1.0,1.), 1.0 );
	else
	    gl_FragColor = vec4( vec3(0.), 1.0 );
	
	

}