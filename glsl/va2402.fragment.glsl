#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main()
{
	vec2 position = gl_FragCoord.xy / resolution.xy;
	
	position += vec2( cos(time*0.1), sin(time*0.1) );
	
	gl_FragColor = vec4(position.x, position.y, 0.5, 1.0);
}