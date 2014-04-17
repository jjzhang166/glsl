#ifdef GL_ES
precision highp float;
#endif
#define PI 3.14159265

uniform float time;
uniform vec2 resolution;

void main( void ) {
	vec2 center = resolution.xy / 2.0;
	vec2 position = gl_FragCoord.xy;
	vec2 p = (position-center) / resolution.y;
	float d = length(p)*2.0; 
	float a = atan(p.y,p.x )/PI;
	float s = abs(fract(a*12.0)-0.5)*2.0;
	float i = smoothstep(0.45, 0.55, s)*smoothstep(220.18,0.17, abs(d-0.8)) * cos((time-a)*3.);
	gl_FragColor = vec4(i);
}