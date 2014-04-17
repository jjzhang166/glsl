#ifdef GL_ES
precision mediump float;
#endif
/*
   Author : Hugo Scott-Slade & Andy Barnard
   Fiddled by Eiyeron
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
		
		c += cos(a+c);
		
	} 
	
	return c;
	
}

void main( void ) {

	vec2 position = tan( gl_FragCoord.xy / resolution.xy );

	float height = sin(position.y*K(time-position.x))-cos(f(position.y));
	float offset = pow(height,3.42);
	
	offset *= (sin(time*tan(2.0)) * 0.2);
	
	vec3 normalColor = vec3(sin( position.x + 3.0*offset), cos( -position.x + offset) , (( position.x*position.y + offset)+K(position.y))/2.0 ); 
	
	gl_FragColor = vec4( normalColor, 1.0 );
}