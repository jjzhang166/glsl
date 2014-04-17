#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 mouse;
uniform vec2 resolution;

void main( void )
{
	float distance = distance(gl_FragCoord.xy, mouse * resolution) / resolution.x;
		
	float fTemp = pow(distance, 0.999);
	
	float fR = 160.0;
	float fG = 80.0;
	float fB = 40.0;
	
	float r = clamp(1.0 - fTemp * fR, 0.0, 1.0);
	float g = clamp(1.0 - fTemp * fG, 0.0, 1.0);
	float b = clamp(1.0 - fTemp * fB, 0.0, 1.0);

	gl_FragColor = vec4(r, g, b, 1.0);
}