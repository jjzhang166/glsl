#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
//gt
void main( void ) {
	
	vec3 color;
	float sum = 0.0;
	float size = 25.0;
	float r = 2.0;
	float g = 1.0;
	
	const float k = 5.;
	
	vec2 uPos = ( gl_FragCoord.xy / resolution.xy );
	float dx = exp( uPos.x*0.085);
	float dy = exp( uPos.x*0.085);
	float t = time * exp(1.0*dx) * (1.5);
	float t2 = time * exp(1.0*dy) * (1.0);
		

	for (int i = 0; i < 2; ++i) {
		vec2 position = resolution / 2.0;
		position.x += sin(t + 10.0 * float(i)) * 90.0;
		position.y += cos(t2+ 5.0 * float(i)) * 50.0;
		
		float dist = length(gl_FragCoord.xy - position);

		sum += size / pow(dist, g);
	}
	
	if (sum > r) color = vec3(1,1,1);
	color = vec3( floor(sum*100.0)/(50.0*12.0) );
	gl_FragColor = vec4(color, 1);
}