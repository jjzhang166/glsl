#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float Pi = 3.14159265;

void main( void ) 
{
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	
	vec3 camera_position = vec3( 0.0, 0.0, -10.0);
	
	gl_FragColor = vec4( uv.x, 0.0, uv.y, 1.0 );

}