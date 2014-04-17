#ifdef GL_ES
precision mediump float; 
#endif

uniform float time;
uniform vec2 mouse, resolution;

float scale = 1.5;

void main(void) {
	vec2 uPos = ( gl_FragCoord.xy / resolution.xy );//normalize wrt y axis
	uPos.x += time / 5.0;
	uPos.y -= time / 5.0;
	
	uPos -= mouse;
	
	// background color
	vec3 color = vec3(1.0,1.0,1.0);
	
	for(float i = 0.0; i < 5.0; ++i) {
		uPos.x += cos((time / 50.0) + uPos.y * i);
		uPos.y += sin((time / 75.0) + uPos.x * i);
		
		uPos.x *= scale + (i / 10.0);
		uPos.y *= scale + (i / 10.0);
		
		float fTemp = abs(((uPos.x * 0.5) / (uPos.y * 1.0)) / 150.0);
		float mouseavg = (mouse.x + mouse.y) / 2.0;
		float r = fTemp * (sin(uPos.x * 0.5) * 100.0);
		float g = fTemp * (cos(uPos.y * 0.5) * 100.0);
		float b = fTemp * (cos(-uPos.x * 0.6) * 100.0);
		
		color += vec3(r,g,b);
	}
	
	gl_FragColor = vec4(color.r - 0.8, color.g - 0.1, color.b - 0.8, 0.5);
}