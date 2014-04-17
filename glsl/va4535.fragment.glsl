#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float scale = 2.5;

void main(void) {
	vec2 uPos = ( gl_FragCoord.xy / resolution.xy );//normalize wrt y axis
	uPos.x += time / 1000.0;
	uPos.y -= time / 1000.0;
	
	// background color
	vec3 color = vec3(3.5,1.5,0.2);
	
	for(float i = 0.0; i < 5.0; ++i) {
		
		uPos.x += cos((time / 30.0) + uPos.y);
		uPos.y += sin((time / 20.0) + uPos.x);
		
		uPos.x *= scale + (i / 10.0);
		uPos.y *= scale + (i / 2.0);
		
		float fTemp = abs(((uPos.x * 0.5) / (uPos.y * 1.0)) / 150.0);
		float r = fTemp * (sin(uPos.x * 0.5) * 100.0) - 0.02;
		float g = fTemp * (cos(uPos.y * 0.5) * 100.0) + 0.02;
		float b = fTemp * (cos(-uPos.x * 0.5) * 100.0) - 0.02;
		
		color += vec3(r,g,b);
	}
	
	gl_FragColor = vec4(color / 10.0, 1.0);
}