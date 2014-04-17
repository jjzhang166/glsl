#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void )
{
	vec2 position = (( (gl_FragCoord.xy -resolution.xy/2.) / resolution.xy ) )/ 0.002;
	//vec2 position = (( gl_FragCoord.xy / resolution.xy ) + mouse )/ 0.01;
	float t = time*1.;
	float x = abs(position.x/3.)+1.+sin(t);
	float y = abs(position.y/3.)+1.+cos(t);
	
	float color = 0.0;
	//color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	//color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	//color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	//color *= sin( time / 10.0 ) * 0.5;

	
	
	color = x*y * (-3.+2.*sin(t));
	

	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}