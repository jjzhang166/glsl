#ifdef GL_ES
precision mediump float;
#endif
uniform vec2 resolution;

void main( void ) {
	vec2 pos = gl_FragCoord.xy;
	vec3 color = vec3(0.3);
	
	//tile size in pixels
	float tile = 50.0;
	
	//brick
	float col = floor(pos.x/tile);
	if (mod(col, 2.0) < 1.0)
		pos.y += tile/2.0;
	
	//line width
	float pixel = 1.0;
	
	//horiz lines
	if (mod(pos.x+pixel/2.0, 50.0) <= pixel)
		color = vec3(0.5);
	
	//vert lines
	if (mod(pos.y+pixel/2.0, tile) <= pixel)
		color = vec3(0.5);
	
	gl_FragColor = vec4(color, 1.0);
}