#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 lookupCol(float f)
{
	return vec3(f, f/1.5, f/3.0);
}

void main( void ) {
	vec2 p = gl_FragCoord.xy;
	p = p / resolution.xy;	// 0 to 1
	vec4 marea = vec4(-1.0, -1.0, 2.0, 2.0);	// (x, y, w, h)
	vec2 m = (mouse * marea.zw) + marea.xy;
	
	float s = 2.0/time;
	vec4 area = vec4(m, s, s);	// (x, y, w, h)
	// area = vec4(-1.0, -1.0, 2.0, 2.0);
	p = (p * area.zw) + area.xy;
	
	vec4 insideColor = vec4(0.1, 0.7, 0.9, 1.0);
	vec2 c = p;
	//vec2 c = vec2(0.285, 0.0);
	//vec2 c = vec2(mouse);
	//vec2 c = vec2(-1.0 + 2.0 * mouse);
	//float t = time / 2.;
	//vec2 c = vec2(sin(t), cos(t));
	vec2 z = p;
	const float maxIterations = 1000.0;
	gl_FragColor = insideColor;
	for (float i = 0.0; i < maxIterations; i += 1.0)
	{
		// Z(n+1) = Z(n)^2 + c;
		// Using the FOIL method
		z = vec2(z.x*z.x - z.y*z.y, 2.0*z.x*z.y) + c;
		
		if (dot(z, z) > 4.0)
		{
			gl_FragColor = vec4(lookupCol(i / 100.), 1.0);
			break;
		}
	}
}