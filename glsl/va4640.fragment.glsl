// by davedes

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

//ukf anyone? :D //MrOMGWTF

void main(void) {
	//our final colour
	vec4 vColor = vec4(0.0, 0.25, 1.0, 1.0);
	
	float padding = 1.0;
	float sharpness = 0.8; //1.0 => sharp
	
	vec2 c = vec2(resolution.x/2.0, resolution.y/2.0);
	
	//for simplicity, assume we're dealing with square sizes
	float dist = resolution.y/2.0 - distance(gl_FragCoord.xy, c);
	
	//padding from edge, incase desired...
	dist -= padding;
	
	vec4 color = vec4(dist, dist, dist, 1.0);
	
	//smooth or sharpen edge
	color = mix(vec4(0.0), color, sharpness);	
	
	//clamp to rgb range so we can multiply with vertex color
	color = clamp(color, 0.0, 1.0);
		
	gl_FragColor = color * vColor;
}