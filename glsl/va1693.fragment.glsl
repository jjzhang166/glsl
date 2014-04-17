#ifdef GL_ES
precision highp float;
#endif
//19021214051919481
uniform float time;
//carrier defined
uniform vec2 resolution;

float offset = 10.0;
float modval = 3000.3;
float zoomDist = 9.0;
float timeMult = 1.0;
float radius = 40.0 + sin(time * 10.);
float rand(vec2 co){  return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453); }


// process not person
void main( void ) {
	float tim = time * timeMult;
	vec2 position = (gl_FragCoord.xy - resolution * 0.5) / resolution.yy;
	position *= zoomDist;

	float col = sin(length(position.x + rand(position)));
	float col2 = sin(length(position.y + rand(position))+ tim);

	float col3 = sin(length(vec2(col,col2) * (modval * 0.01)));

	gl_FragColor = vec4(col3 - max(col, col2), col3, max(col,col2), 1.0);
}