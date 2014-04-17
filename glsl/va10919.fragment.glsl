#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


const float pi = 3.14159205;

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;

	vec3 color = vec3(0);
	
	float velocity1 = 0.1;
	float velocity2 = 0.3;
	float velocity3 = 0.6;
	float velocity4 = 0.45;
	float velocity5 = 0.2;
	
	vec2 pos1 = vec2(0.7, 0.5);
	vec2 pos2 = vec2(0.3, 0.5 * sin(time*velocity3));
	
	float x1 = pow((position.x - pos1.x) * abs(sin(time*velocity1) * abs(sin(time*velocity3))), 2.0);
	float y1 = pow((position.y - pos1.y) * abs(sin(time*velocity2) * abs(sin(time*velocity3))), 2.0);
	
	float x2 = pow((position.x - pos1.x) * abs(sin(time*velocity4) * abs(sin(time*velocity3))), 2.0);
	float y2 = pow((position.y - pos1.y) * abs(sin(time*velocity5) * abs(sin(time*velocity3))), 2.0);
	
	float wave1 = abs(sin(1.0/sqrt(x1+y1)));
	float wave2 = abs(sin(1.0/sqrt(x2+y2)));
	
	color.r = wave1 + wave2;
	//color.g = clamp(sin(time), 0.0, 255.0);
	//color.b = clamp(cos(time/0.25), 0.0, 255.0);
	color.g = sin(time/2.0 * 5.0) + abs(sqrt(tan(time * 2.0 * pi)));
	color.b =  clamp(pow(wave1, 2.0) / wave2, 0.0, 125.0);

	
	gl_FragColor = vec4(color, 1.0);
}