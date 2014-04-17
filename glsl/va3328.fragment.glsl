#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	vec3 clr = vec3(0.0);
	if(position.y < sin(position.x * 3.0 + time)*0.2 + 0.7 && position.y > sin(position.x * 3.0 + time)*0.2 + 0.4 )
	{
		float color = sin((position.x) + time*3.0);
		clr = vec3( color,0.2,0);
	}

	
	gl_FragColor = vec4( clr,1.0 );
}