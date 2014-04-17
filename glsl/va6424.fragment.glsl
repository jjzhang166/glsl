#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
vec2 d_pos = vec2(time * 100.0, time * 100.0);
uniform vec2 resolution;

float size = 64.0;
float border_size = 8.0; 
float hipst = 8.0;

float rand (vec2 co){
    return fract(sin((co.x+co.y*1e3)*1e-3) * 1e5) * 0.05;
}
void main( void ) {
	
	vec2 position = gl_FragCoord.xy + d_pos;
	
	vec3 color_0 = vec3(0.25, 0.25, 0.25)+ rand(floor(position));
	vec3 color_1 = vec3(0.5, 0.5, 0.5)+ rand(floor(position));
	vec3 border_color = vec3(75.0/255.0, 75.0/255.0, 75.0/255.0);
	
	vec3 color = color_0;
	
	int x = int(position.x / size);
	int y = int(position.y / size);
	if (position.x < 0.0) x -= 1;
	if (position.y < 0.0) y -= 1;
	
	if (mod(float(x),2.0) == 0.0) {
		if (mod(float(y),2.0) != 0.0)
		color = color_1;
	} else if (mod(float(y),2.0) == 0.0) color = color_1;
	
	if (mod(float(x),2.0) == 0.0) {
		if (mod(float(y),2.0) != 0.0)
		color = color_1;
	} else if (mod(float(y),2.0) == 0.0) color = color_1;
		
	color *= 1.0 - hipst / (gl_FragCoord.x);
	color *= 1.0 - hipst / (resolution.x - gl_FragCoord.x);
	color *= 1.0 - hipst / (gl_FragCoord.y);
	color *= 1.0 - hipst / (resolution.y - gl_FragCoord.y);
	
	if (gl_FragCoord.x < border_size || gl_FragCoord.x > resolution.x-border_size ||
		gl_FragCoord.y < border_size || gl_FragCoord.y > resolution.y-border_size) color = border_color;
	
	if (int(gl_FragCoord.x) == int(border_size) &&
		int(gl_FragCoord.y) >= int(border_size) &&
		int(gl_FragCoord.y) <= int(resolution.y - border_size - 1.0)) color = border_color * 1.5;
		
	if (int(gl_FragCoord.x) == int(resolution.x - border_size - 1.0) &&
		int(gl_FragCoord.y) >= int(border_size) &&
		int(gl_FragCoord.y) <= int(resolution.y - border_size - 1.0)) color = border_color * 1.5;
		
	if (int(gl_FragCoord.y) == int(border_size) &&
		int(gl_FragCoord.x) >= int(border_size) &&
		int(gl_FragCoord.x) <= int(resolution.x - border_size - 1.0)) color = border_color * 1.5;
		
	if (int(gl_FragCoord.y) == int(resolution.y - border_size - 1.0) &&
		int(gl_FragCoord.x) >= int(border_size) &&
		int(gl_FragCoord.x) <= int(resolution.x - border_size - 1.0)) color = border_color * 1.5;
		
	gl_FragColor = vec4( color , 1.0 );
}