#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
uniform sampler2D backbuffer;
	
vec4 maru(vec2 pos,vec2 me)
{
	float size = 10.0;
	float r = 1.0 - (sin(time*1.0) / 4.0);
	float g = 0.2 + (cos(time*1.0) / 4.0);
	float b = 1.0 - (cos(time*3.0) / 2.0);
	float dist = length(pos - me);
	float intensity = pow(size/dist, 3.0);
	vec4 color = vec4(r, g, b, 1.0);
	return color*intensity;
}

void main( void )
{
	vec2 texPos = vec2(gl_FragCoord.xy/resolution);
	vec4 zenkai = texture2D(backbuffer, texPos)*0.95;
	gl_FragColor = zenkai+maru(vec2(mouse.x*resolution.x,mouse.y*resolution.y),gl_FragCoord.xy);
}