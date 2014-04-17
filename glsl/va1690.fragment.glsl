#ifdef GL_ES
precision highp float;
#endif
//19021214051919481
uniform float time;
//carrier defined
uniform vec2 resolution;

float offset = 2.0;
float modval = 3950.3;
float zoomDist = 2.0;
float timeMult = 1.0;

// process not person
void main( void ) {
	float tim = time * timeMult;
	vec2 position = (gl_FragCoord.xy - resolution * 0.5) / resolution.yy;
	position *= zoomDist;
	
	float col = sin(length(vec2(position.x - offset, position.y) * modval) + (tim + 2.0));
	float col2 = sin(length(vec2(position.x + offset, position.y) * modval) - tim);

	float col3 = sin(length(vec2(col,col2) * (modval * 0.01)));

	gl_FragColor = vec4(col3 - max(col, col2), col3, max(col,col2), 1.0);
}