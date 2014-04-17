//Dr.Zoidberg
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void ) {
	vec2 p = gl_FragCoord.xy / resolution.y;
	vec3 color = vec3(0.0,0.0,0.0);
	p.y -= 0.5;
	p.x -= (resolution.x / resolution.y) * 0.5;
	p *= 10.0;
	float intensity = 0.003;
	float grid_intensity = 0.10;
	
	//sin(x)^2 + cos(x)^2 = 1
	float fx1 = sin(p.x - time)*sin(p.x - time);
	float fx2 = cos(p.x - time)*cos(p.x - time);
	float fx3 = 1.0;
	color = vec3(intensity*1.5/abs(fx1 - p.y), intensity*0.6/abs(fx1 - p.y),intensity*0.6/abs(fx1 - p.y));
	color+= vec3(intensity*0.8/abs(fx2 - p.y), intensity*0.8/abs(fx2 - p.y),intensity*1.5/abs(fx2 - p.y));
	//color+= vec3(intensity*1.5/abs(fx3 - p.y), intensity*0.6/abs(fx3 - p.y),intensity*1.5/abs(fx3 - p.y));
	gl_FragColor = vec4(color,1.0);
}