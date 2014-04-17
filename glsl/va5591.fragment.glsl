// by davedes
// simple circle outline, not the best technique...

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main(void) {
	//our final desired color
	vec4 vColor = vec4(0.4, 0.7, 0.5, 1.0);
	
	//adjust padding to keep circle within bounds...
	float padding = 4.0;
	
	//play with these values
	float smooth1 = 8.0;
	float smooth2 = 10.0; 
	
	vec2 c = vec2(resolution.x/2.0, resolution.y/2.0);
	
	//for simplicity, assume we're dealing with square sizes
	float dist = resolution.y/2.0 - distance(gl_FragCoord.xy, c);
	
	//padding from edge, incase desired...
	dist -= padding;
	
	vec4 color = vec4(dist, dist, dist, 1.0);
	
	//get outline only
	color = mix(vec4(1.0), vec4(0.0), smoothstep(smooth1, smooth2, dist*dist));	
	
	//clamp to rgb range so we can multiply with vertex color
	color = clamp(color, 0.0, 1.0);
		
	gl_FragColor = color * vColor;
}