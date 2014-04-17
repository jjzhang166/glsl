// Simple Amiga oldscool - polaris

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution;

	vec3 c = vec3(0.0);
	
	float r = clamp(100.0*sin(uv.y*5.0+(0.0+sin(uv.x*(1.0+10.0*sin(time*2.0)))/3.0)),0.99,100.0) - 99.0;
	float g = clamp(100.0*sin(uv.y*5.0-1.50+(0.0+sin(uv.x*(1.0+7.0*cos(time*1.0)))/3.0)),0.99,100.0) - 99.0;
	float b = clamp(100.0*sin(uv.y*5.0-2.5+(0.0+sin(uv.x*(1.0+8.0*sin(time*1.40)))/3.0)),0.99,100.0) - 99.0;
	c = vec3( r, g, b);
	
	gl_FragColor = vec4(c,1.0);
}