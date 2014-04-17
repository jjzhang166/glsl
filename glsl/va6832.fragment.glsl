#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 uv = gl_FragCoord.xy / resolution;
	vec4 color = vec4(uv, 0.0, 1.0);
	
	vec2 pos = uv * 2.0 - 1.0;
	float distToCenter = length(pos);
	float distToBorder = distToCenter - 0.5;
	
	if (distToBorder < 0.0)
		color = vec4(1.0);
	if (distToBorder < -0.3)
		color = vec4(1.0, 1.0, 0.0, 0.0);
	
	
	gl_FragColor = color;
	
}