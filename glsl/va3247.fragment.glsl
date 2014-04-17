#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position =  ((-1.+2.*gl_FragCoord.xy / resolution.xy)-(-1.+2.*mouse));
        
	float z = pow(position.x , 2.) + pow(position.y, 2.);
	float r = sqrt( dot(position, position) );
	float color = 0.0;
	color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;

	gl_FragColor = vec4( sin(5.*( (-2.*(r-time) ) ))*vec3( .3 , color , 1.-color) , 1.0 );

}