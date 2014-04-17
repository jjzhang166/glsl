#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 lookupCol(float f)
{
	return vec3(f, f/10.75, f/3.0);
}

void main( void ) {
	vec2 p = gl_FragCoord.xy;
	p = -1.0 + 2.0 * p / resolution.xy;
	//p.x -= 0.5;
	
	vec4 insideColor = vec4(0.1, 0.7, 0.9, 1.0);
	//vec2 c = p;
	//vec2 c = vec2(0.285, 0.0);
	//vec2 c = vec2(-0.4, 0.6);
	vec2 c = vec2(-1.0 + 2.0 * mouse);
	vec2 z = p;
	const float maxIterations = 150.0;
	gl_FragColor = insideColor;
	for (float i = 0.0; i < maxIterations; i += 1.0)
	{
		// Z(n+1) = Z(n)^2 + c;
		// Using the FOIL method
		z = vec2(z.x*z.x - z.y*z.y, 2.0*z.x*z.y) + c;
		
		if (dot(z, z) > 4.0)
		{
			gl_FragColor = vec4(lookupCol(i / maxIterations), 1.0);
			break;
		}
	}
}