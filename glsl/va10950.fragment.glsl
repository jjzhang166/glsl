#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {

	
	vec2 position = (( gl_FragCoord.xy / resolution.xy )-0.5)*3.14;
	

	float color = 0.0;
	
	float n = 1.0 + (mouse.x*80.0);
	float m = 1.0 + (mouse.y*80.0);
	
	color = cos(position.x*n)*cos(position.y*m) - cos(position.x*m)*cos(position.y*n) ;
	color *= color;
	color *= 50.0;
	color = 1.0-color;
	color += rand(position*time)*2.0; 
	 

	gl_FragColor = vec4( color,color,color, 1.0 );

}