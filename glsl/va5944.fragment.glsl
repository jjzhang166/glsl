#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	vec2 res = resolution.xy;
		
	vec2 position = ( gl_FragCoord.xy / res.xy);
		
	vec2 z = position;
	
	for (float i = 0.0; i < 1000.0; i += 1.0)
	{
		z = vec2(z.x*z.x - z.y*z.y*mouse.y, 2.0*z.x*z.y) + 0.40;
		
		if (dot(z, z) > 100.0)
		{
			gl_FragColor = vec4(mix(vec3(0,0,0), vec3(255,255,255), z.x/10.0), 1.0);
			break;
		}
	}
}