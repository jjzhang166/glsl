#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 5.0;

	vec3 color;
	
	for(float i = 0.0; i < 2000.0; i++)
	{
		color.xz = sin(time / 5.0) * position.xy;
		color.xyz += dot(color.xy, position) * cross(color.xyz, vec3(cos(time / 20.0) * position.x, sin(time / 40.0) * position.y, sin(time / 15.0) * cos(time / 30.0)));
		
		gl_FragColor = vec4(color, 1.0 );
	}
}