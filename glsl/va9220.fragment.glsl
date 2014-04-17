#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

void main( void ) {
	
	//Block Based Compression Episode 2! (Abridged version...)
	vec2 uv		= gl_FragCoord.xy / resolution.xy; 			//Continuous linear 0-1 uv map(a plane with positive slope)
	float w 	= length(uv-mouse);
	
	vec3 n		= vec3(4., 4., 4.);					
	
	vec3 uvw	= floor(fract(vec3(uv/w,length(uv)/w)*n)*2.);
	
	gl_FragColor 	= vec4(uvw, 0.0); //needs more smooth minmax?

	
	/**///- sphinx
	
}