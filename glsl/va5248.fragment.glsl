#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//beatiful sun :)
//MrOMGWTF

#define BLADES 6.0
#define BIAS 0.1
#define SHARPNESS 5.0
#define COLOR 0.82, 0.65, 0.4
#define BG 0.34, 0.52, 0.76

void main( void ) {

	vec2 position = (( gl_FragCoord.xy / resolution.xy ) - vec2(0.5)) / vec2(resolution.y/resolution.x,1.0);
	vec3 color = vec3(0.);
	float ct,st;
	//ct = cos(time);
	//st = sin(time);
	//ct *= 0.2;
	//st *= 0.2;
	float blade = clamp(pow(sin(atan(position.y + ct,position.x + st)*BLADES)+BIAS, SHARPNESS), 0.0, 1.0);
	
	color = mix(vec3(0.34, 0.5, 1.0), vec3(0.0, 0.5, 1.0), (position.y + 1.0) * 0.5);
	
	color += (vec3(0.95, 0.65, 0.30) * 1.0 / distance(vec2(0.0), position + vec2(st, ct)) * 0.075);
	color += (vec3(0.95, 0.45, 0.30) * min(1.0, blade *0.7)) * (1.0 / distance(vec2(0.0, 0.0), position + vec2(st, ct)) * 0.1);
	
	gl_FragColor = vec4( color, 1.0 );

}