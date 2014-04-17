#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy;
	vec2 center = mouse.xy*resolution.xy;
	vec4  color = vec4(0.0, 0.0, 0.0, 1.0);
	float r = 50.0;

        if( length(center - position ) < r)
	{
		color = vec4(1.0, 0.0, 0.0, 1.0);
	}

	gl_FragColor = color;
	
}