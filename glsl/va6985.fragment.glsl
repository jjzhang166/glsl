#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {
	float sum = 0.0;
	float size = resolution.x * 4.0;

	float g = 3.;
	int num = 360;
	for (int i = 0; i < 360; ++i) {
		vec2 position = resolution / 2.0;
		position.x += sin(time * .20 + 8. * float(i)) * resolution.x * 0.4;
		position.y += cos(time * .80 + 14. * float(i)) * resolution.y * 0.3;

		float dist = length(gl_FragCoord.xy - position);
        
		sum += size / pow(dist, g);
	}
    
	vec4 color = vec4(0,0,0,1);
	float val = sum / float(num);
	color = vec4(val*.05, val*0.1, val*.3, 1);
    
	gl_FragColor = vec4(color);
}