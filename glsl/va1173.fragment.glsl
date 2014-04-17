

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float cubicPulse( float c, float w, float x )
{
    x = abs(x - c);
    if( x>w ) return 0.0;
    x /= w;
    return 1.0 - x*x*(3.0-2.0*x);
}

void main( void ) {
	float PI = 3.1415926535897932384626433; 
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	position = position * vec2(2.0) - vec2(1.0); 	
	
	// Draw Coordinate Axis
	if(distance(position.y,0.0)<0.002){
		gl_FragColor = vec4(1,0,0,1); 
		return; 
	}
	
	if(distance(position.x,0.0)<0.002){
		gl_FragColor = vec4(0,1,0,1); 
		return; 
	}
	
	// Define Envelope
	float envelope = sin(position.x*PI); 
	if(position.y > envelope){
		discard;
	}
	
	//float color = cubicPulse(0.0,envelope,position.y);
	float color = 1.0;
	//color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	//color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	//color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	//color *= sin( time / 10.0 ) * 0.5;

	//gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );
	gl_FragColor = vec4(color,color,color,1.0);
}