
precision mediump float;


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 calcColor(vec2 pos) {
	float r = sin(time/((pos.x-pos.x*pos.x)+0.6));
	float g,b = sin((time)+(pos.x));
	//float b = sin(time*pos.x);
	return vec3(r, g, b);
}

void main( void ) {
	vec2 position = gl_FragCoord.xy / resolution;
	
	vec3 color = calcColor(position);
	
	gl_FragColor = vec4(color, 1.0);
}