#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	
	vec2 pos = gl_FragCoord.xy / resolution.xy;
	pos.y = (pos.y * 2.0) - 1.0;
	pos.x *= 6.24;
	
	float Height = sin(pos.x);
	if(distance(pos.y, Height) < 0.05)
	{
		gl_FragColor = vec4(1.0,1.0,1.0,0.0);
	}
	
	
	
	
}
