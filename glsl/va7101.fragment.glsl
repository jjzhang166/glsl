#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	vec3 color;
	float sum = 0.0;
	float sum2 = 0.0;
	float sum3 = 0.0;
	float sum4 = 0.0;
	float size = 3.0;
	float r = 3.3;
	float g = 1.0;
	for (int i = 0; i < 180; ++i) {
		vec2 position = resolution / 2.0;
		float z=position.x+position.y;
		position.x += sin(time/2.0 + 2.0* sin(time/3.0) + float(i) * z/ (50.0 +0.1*sin(time/7.0) )) * 250.0;
		position.y += cos(time/3.0 + 2.0* sin(time/2.0) + float(i) * z/ (50.0 +0.1*cos(time/3.0) )) * 140.0;
		
		if (i == 0) position = mouse * resolution;
		
		float dist = length(gl_FragCoord.xy - position);

		sum += size / pow(dist, g);
		sum2 += (size+5.0) / pow(dist, g);
		sum3 += (size+10.0) / pow(dist, g);
		sum4 += (size+15.0) / pow(dist, g);
	}
	
	vec3 fancy_color = vec3(sin(time * 0.001), cos(time * 0.01), sin(time * 0.1)) * 0.1;
	
	if (sum > r) color = vec3(1,1,1) + fancy_color;
	if (sum2 > r) color += vec3(0.1, 0.1, 0.1) + fancy_color;
	if (sum3 > r) color += vec3(0.1, 0.1, 0.1) + fancy_color;
	if (sum4 > r) color += vec3(0.1, 0.1, 0.1) + fancy_color;
	
	gl_FragColor = vec4(color, 1);
}