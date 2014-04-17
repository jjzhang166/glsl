#ifdef GL_ES
precision highp float;
#endif

uniform vec3 unResolution;

float noise(in vec2 x);


void main( void ) {
	
	vec2 q = gl_FragCoord.xy/unResolution.xy;
	vec2 p  = -1.0 + 2.0*q;
	float f = noise( p );
		
	vec3 col = vec3( f, f, f );
	gl_FragColor = vec4(col,1.0);

}