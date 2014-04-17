#ifdef GL_ES
precision mediump float;
#endif

// mouse: [0 1]
// glFragCoord: [0 resolution]

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
uniform sampler2D backbuffer;
	
void main( void )
{
	vec2 texPos = gl_FragCoord.xy / resolution;
	
	float dist = distance(mouse, texPos);
	
	gl_FragColor.r += (cos(dist * 500.0) * sin(dist * 20.0 ));
	
	gl_FragColor.r += cos(gl_FragCoord.x / resolution.x * 15.0) * (sin(time * 2.0) / 4.0 + 0.5);
	gl_FragColor.r += cos(gl_FragCoord.y / resolution.y * 15.0) * (sin(time * 2.0) / 4.0 + 0.5);
	
	gl_FragColor = (gl_FragColor * 0.2 + texture2D(backbuffer, texPos)) * 0.80;
}