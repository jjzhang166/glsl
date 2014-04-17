#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

bool drawPoint(vec2 point, vec2 position) {
	return (distance(point, position) < 0.01);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	vec3 color = vec3(0.0);
	
	vec2 scale = vec2(1.2, 1.0);
	
	vec3 blue = vec3(0.0, 0.0, 1.0);
	
	vec2 pos1 = vec2(0.25, 0.25);
	vec2 pos2 = vec2(0.75, 0.25);
	vec2 pos3 = vec2(0.75, 0.75);
	vec2 pos4 = vec2(0.25, 0.75);
	
	pos1 *= scale;
	pos2 *= scale;
	pos3 *= scale;
	pos4 *= scale;
	
	if (drawPoint(pos1, position)) color = blue;
	if (drawPoint(pos2, position)) color = blue;
	if (drawPoint(pos3, position)) color = blue;
	if (drawPoint(pos4, position)) color = blue;
	
	gl_FragColor = vec4(color, 1.0 );


}