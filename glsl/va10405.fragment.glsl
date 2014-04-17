#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;
uniform sampler2D backbuffer;
	
vec4 maru(vec2 pos,vec2 me)
{
	float dist = length(pos - me);
	float intensity = pow(10.0/dist, 2.0);
	vec4 color = vec4(1.0,1.0,1.0,1.0);
	return color*intensity;
}

void main( void )
{
	vec2 texPos = vec2(gl_FragCoord.xy/resolution);
	vec4 zenkai = texture2D(backbuffer, texPos)*0.7;
	gl_FragColor = zenkai+maru(vec2(mouse.x*resolution.x,mouse.y*resolution.y),gl_FragCoord.xy);
}