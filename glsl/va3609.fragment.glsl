#ifdef GL_ES
precision mediump float;
#endif
/*
   Author : Hugo Scott-Slade & Andy Barnard
*/
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float f ( float a ) {

	return sin(a);
	
}

float K ( float a ) {
	
	float c = 0.0;

	for( float b = 0.0; b < 4.0; b += 1.0 ) {
		
		c += sin(a);
		
	} 
	
	return c;
	
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float height = position.y+sin(position.x*K(time))+position.x;
	float offset = pow(height,2.5);
	
	offset *= (sin(time*2.0) * 0.2);
	
	vec3 normalColor = vec3(1.0, fract( position.x + offset) , K(position.y) ); 
	
	gl_FragColor = vec4( normalColor, 1.0 );
}