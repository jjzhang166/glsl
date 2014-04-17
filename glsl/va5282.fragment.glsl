#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec3 color;

float loopto(float a, float top) {
	a = mod(a, top*2.0);
	if(a < top)
		return a;
	else
		return top*2.0-a;
}

void main( void ) {
	vec2 position = gl_FragCoord.xy / resolution.xy;
	vec3 color = vec3(abs(sin(position.y*loopto(time, 2.3) / 0.09)), abs(sin(position.x*loopto(time, 2.3) / 0.04)), 0); 
	//float dist = mod(distance(position, mouse), 10.0);
	
	gl_FragColor = vec4(color.r, color.g, color.b, 1.0);
}