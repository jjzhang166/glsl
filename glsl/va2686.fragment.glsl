#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + (mouse-0.5) / 4.0;
	position -= 0.5;
	
	float color = 0.05 / dot(position,position);
	

	if(color < 5.0)
		gl_FragColor = vec4( vec3( color, color * 0.2, 0.0 ) , 1.0 );
	else
	{
		gl_FragColor = vec4( vec3( color, color * 0.2, 0.0 ) , 1.0 );
	}
	
		

}

