#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float red = 0.1;
	float green = 0.1;
	float blue = 0.1;
	
	if(position.x<0.5) red=0.5;
	if(position.y<0.5) blue=0.5;

	gl_FragColor = vec4( vec3(red,green,blue),1.0 );
}