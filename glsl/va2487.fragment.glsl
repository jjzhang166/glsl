// by @zacharydenton

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	const int max_iterations = 200;
	vec2 center = vec2(0.749, -0.1);
	float scale = 0.001;
	
	vec2 c, z;
	c.x = (gl_FragCoord.x / resolution.x - 0.5) * scale - center.x + mouse.x * scale;
	c.y = (gl_FragCoord.y / resolution.x - 0.5) * scale - center.y + mouse.y * scale;
	z = c;
	
	int iterations;
	for (int i = 0; i <= max_iterations; i++) {
		iterations = i;
		float x = (z.x * z.x - z.y * z.y) + c.x;
       		float y = (z.y * z.x + z.x * z.y) + c.y;
        	if ((x * x + y * y) > 4.0) break;
        	z.x = x;
        	z.y = y;
	}

	if (iterations < max_iterations)
		gl_FragColor = vec4(abs(sin(float(iterations))), float(iterations) / float(max_iterations), abs(sin(time / float(iterations))), 0.0);

}