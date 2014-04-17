#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float _dir = 90.0;

float hash( float n ) { return fract(sin(n)*43758.5453); }
vec2 mypos = vec2(0.5,0.5);

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 0.0;

	mypos.x += sin(time)*0.3;
	float dist = distance(position, vec2(sin(time)*0.2, cos(time)*0.2));
	
	
	float factor3d = 0.0;
	
	if(dist > 0.5)
	{
		color += 0.5;
	}
	else
	{
		factor3d = distance(dist, 0.3);
		color += 0.0 + factor3d;
	}
	

	
	gl_FragColor = vec4( color, color, color, 1.0 );

}