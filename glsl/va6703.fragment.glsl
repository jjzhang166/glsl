#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 mouse_pxl = mouse * resolution.xy;
	
	float dist = 30.0;
	float color = 1.0 - min(mod(gl_FragCoord.x, dist), mod(gl_FragCoord.y, dist));
	
	float subcolor = 1.0 - min(mod(gl_FragCoord.x, dist/2.0), mod(gl_FragCoord.y, dist/2.0));
	subcolor = subcolor * 0.75;
	
	float subsubcolor = 1.0 - min(mod(gl_FragCoord.x, dist/4.0), mod(gl_FragCoord.y, dist/4.0));
	subsubcolor = subsubcolor * 0.20;
	
	float mouse_dist = 300.0;
	float alpha = 1.0 - min(distance(gl_FragCoord.xy, mouse_pxl), mouse_dist) / mouse_dist;
	
	float color_strength = max(max(color, subcolor), subsubcolor) * alpha;
	
	float r = position.x * time;
	float g = position.y * time;
	float b = distance(position.x, position.y) * time;
	
	gl_FragColor = vec4( vec3( r,  g , b ) * color_strength, 0.0);
}