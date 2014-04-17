#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform sampler2D bb;

void main( void ) {
    
	float sum = 0.0;
	float size = resolution.x / 2.5;
	vec2 tpos = gl_FragCoord.xy / resolution;
	tpos += vec2(0.01*sin(time), -0.02+.015*cos(time*2.0));
	float g = 1.195;
	int num = 500;
	for (int i = 0; i < 100; ++i) {
		vec2 position = resolution / 2.0;
		position.x += 1.5*sin(time / 3.0 + 1.0 * float(i)) * resolution.x * 0.15;
		position.y += cos(time / 3.0 + (2.0 + sin(time) * 0.01) * float(i)) * resolution.y * 0.25;

		float dist = length(gl_FragCoord.xy - position);

		sum += size / pow(dist, g);
	}
    
	vec4 color = vec4(0,0,0,1);
	float val = sum / float(num
			   );
	color = vec4(val*1.2, val*0.8, 0.0, 1) + texture2D(bb, tpos)*.55;
    
	gl_FragColor = vec4(color);
}