#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec4 finalColor = vec4(0.0);
float color=0.0;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	for(int i = 0; i < 15; i ++)
	{
		color += sin(time + position.x * 30.0) + cos(time-time / time*time + position.y * 3.0) * 0.1;
		color += cos(-time);

	}
	
	for(int i = 0; i < 10; i ++)
	{
		color += sin( -time * time + 0.5 * 2.0 ) / 100.0;
	}
	
	float ref = color*color/color*0.2*color*color*color/0.5;
	
	color *= ref/sin(time*100.0);
	
	finalColor = vec4(0.5,sin(time),sin(time),1.0);
	
	gl_FragColor = finalColor+color*color;

}