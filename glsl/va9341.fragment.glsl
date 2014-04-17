#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float pixie(vec2 position, vec2 mouse) {
	return pow(1.0 - distance(position, mouse)* 0.002, 5000.0);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	vec3 color = vec3(0.0);
	for(int i=0;i<50;i++) {
		vec2 center = vec2(0.5) + 0.5 * cos(time*0.3*float(i)) +  float(i) * 0.1
			* vec2(cos(0.1 * time + float(i)), sin(time * 0.3));
		color += vec3(tan(float(i)), sin(float(i) * 5.0), cos(float(i) * 3.0)) *
			pixie(position, center);
	}
	
	gl_FragColor = vec4(color, 1.0 );

}