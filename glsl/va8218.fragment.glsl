#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D bb;

float noise(float modifier, float uniformity)
{
	float x = 1000.0 + gl_FragCoord.x + 1.0 / modifier;
	float y = 1000.0 + gl_FragCoord.y;
	float r = mod(x / (sin(x) + sin(y)), 1.0);
	return pow(r, uniformity);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy * 2.0) - 1.0;
	position.x *= 1.666666;
	float color = 0.0;
	if(time < 1.0)
	{
		color = noise(2.0, 20.0);	
	}
	else
	{
		vec2 uv = gl_FragCoord.xy / resolution.xy;

		color += texture2D(bb, uv + vec2(0.001, 0.000)).r;
		color += texture2D(bb, uv - vec2(0.001, 0.000)).r;
		
		
		color *= 0.505;
	
	}
	gl_FragColor = vec4( color );

}