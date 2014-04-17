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
	float a = time, cosa = cos(a), sina = sin(a);
	vec2 position = gl_FragCoord.xy / resolution.xy;
	position = vec2(position.x * cosa - position.y * sina, position.y*cosa + position.x * sina); 
	vec3 color = vec3(1, abs(sin(position.x*loopto(time, 2.3) / 0.04)), sin(position.x*position.y*loopto(time, 2.3) / 0.04) ); 
	//float dist = mod(distance(position, mouse), 10.0);
	vec3 color2 = vec3(abs(cos(position.y*loopto(time, 2.3) / 0.04)), 0.5, abs(cos(position.y*loopto(time, 2.3) / 0.04))); 
	vec3 color3 = vec3(abs(cos(position.x*loopto(time, 2.3) / 0.04)), cos(position.x*loopto(time, 2.3) / 0.04), 0.1); 
	vec3 color4 = vec3(0.3, abs(sin(position.y*loopto(time, 2.3) / 0.04)), 0.4); 
	color = cross(color, color2) * 1.5;
	color = cross(color, color3) * 5.0;
	color = cross(color, color4) * 3.0;
	gl_FragColor = vec4(color.r, color.g, color.b, 1.0);
}