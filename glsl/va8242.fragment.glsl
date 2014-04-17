
precision lowp float;


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = 30.0 *(gl_FragCoord.xy-resolution)/resolution.x;
	vec2 newp = position;
	for (int i = 1; i < 5; i ++) {
		newp.y += (0.6/float(i) * cos(float(i * i) * (2.0 * newp.x) )) + (time) * 1.0;	
		newp.x += 0.1 * time * float(i);
	}
	position = newp;
	vec3 color = vec3((sin(position.x * 0.3) + 1.0)* 0.4 + 0.2,(sin(position.y * 0.3  ) + 1.0)* 0.4 + 0.2, (sin((position.x + position.y) * 0.3) + 1.0) * 0.4 + 0.2);
	vec3 mixx = vec3(mix(vec3(0.0),color,sin((gl_FragCoord.y / resolution.y)*3.14)));
	gl_FragColor = vec4(color,1.0);
}