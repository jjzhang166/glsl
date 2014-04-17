

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;



void main( void ) {
	float PI = 3.1415926535897932384626433; 
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	position = position * vec2(2.0) - vec2(1.0); 	
	
	// Define Envelope
	float envelope = sin(position.x*PI); 
	if(position.y > envelope){
		discard;
	}
	
	//float color = cubicPulse(0.0,envelope,position.y);
	float color = 1.0;
	color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;

	//gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );
	gl_FragColor = vec4(color,0.0,0.0,1.0);
}