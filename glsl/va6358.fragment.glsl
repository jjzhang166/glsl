#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float PI = 3.141;

void main( void ) {

	vec2 p = vec2(gl_FragCoord.xy / resolution.xy);
	vec4 col = vec4(0.0, 0.0, 0.0, 1.0);
	float y4 = 0.1-(cos(p.x+mouse.x+time*0.25)*cos(mouse.y+p.x*PI*2.5*(1.0+sin(time*0.15)))*sin(p.x*PI*(mouse.x+cos(time*0.35)*0.15)*35.0)+2.0)*0.25;
	
	col.z += float(sin(time)*1.0 - clamp(mod(floor(cos(resolution.x*(p.y-y4))), gl_FragCoord.x*10.1*pow(cos(time), 0.3)), 0.0, 1.0));// -
	col.x += float(cos(time)*1.0 - clamp(mod(floor(cos(resolution.x*(p.y-y4))-cos(resolution.y*(p.y-y4))), resolution.y*pow(cos(time), 0.3)), 0.0, 1.0));// -
	col.y += float(1.0 - clamp(mod(floor(cos(resolution.x*(p.y-y4))+sin(resolution.y*(0.1+p.y-y4))), resolution.y), 0.0, 1.0));// -
	gl_FragColor = col;
}