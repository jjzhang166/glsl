//something interesting // going to make a 2d FM visualizer

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float pi = 3.14159265358;

float coordversion (float coord)
{
	return coord/2.0+0.5;
}

void main( void )
{
	float time_mod = time * pi;
	
	float viewscale = min(resolution.x, resolution.y) / 100.0;
	vec2 position = ( gl_FragCoord.xy / viewscale );
	
	float r, g, b = 0.0;
	float a = 1.0;
	
	float color = 0.0;
		
	float v = (coordversion(sin(position.x-cos(time_mod-pi/2.0)))+coordversion(sin(position.y+time_mod)))/2.0;
	
	v *= coordversion(sin((position.x-position.y)/2.0));
	
	r = v;
	g = v;
	b = v;
	
	gl_FragColor = vec4(r, g, b, a);

}