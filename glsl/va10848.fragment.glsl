#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 pixel = 1./resolution;
	
	if( position.x > 100.0)
	{
		gl_FragColor = vec4(4.0,3.0,0.0,4.0);
	} 
	else 
	{
		gl_FragColor = vec4(1.0,2.0,2.0,2.0);
	}
	
	
}
