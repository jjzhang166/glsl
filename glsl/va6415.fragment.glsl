#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float size = 32.0;

void main( void ) {
	
	vec2 position = gl_FragCoord.xy + vec2(0.0, time * 50.0);
	
	vec3 color_0 = vec3(0.25, 0.25, 0.25);
	vec3 color_1 = vec3(0.5, 0.5, 0.5);
	
	vec3 color = color_0;
	
	int x = int(position.x / size);
	int y = int(position.y / size);
	if (position.x < 0.0) x -= 1;
	if (position.y < 0.0) y -= 1;
	
	if (mod(float(x),2.0) == 0.0) {
		if (mod(float(y),2.0) != 0.0)
		color = color_1;
	} else if (mod(float(y),2.0) == 0.0) color = color_1;
		
	color *= 1.0 - 2.0 / (gl_FragCoord.x);
	color *= 1.0 - 4.0 / (resolution.x - gl_FragCoord.x);
		
	gl_FragColor = vec4( color , 1.0 );
}