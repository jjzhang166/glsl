#ifdef GL_ES
precision mediump float;
#endif

// Metashadebobs - mousey: clear buffer, mousex: speed
// Amiga forever

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
	
	vec4 color = vec4(0,0,0.1,1.0);
	if (mouse.y < 0.5) {
		color = texture2D(backbuffer, vec2(gl_FragCoord.x,gl_FragCoord.y)/resolution);
	}
	float sum = 0.0;
	float size = 7.0;
	float r = 3.0;
	for (int i = 1; i < 60; ++i) {
		vec2 position = resolution / 2.0;
		position.x += sin(time*mouse.x*2.0 + mouse.x*7.0*float(i)) * resolution.x*0.4;
		position.y += cos(time*mouse.x*2.0 + mouse.x*3.0*float(i)) * resolution.y*0.4;
		float dist = length(gl_FragCoord.xy - position);
		sum += size / pow(dist, 1.0);
	}
	
	if (sum > r) color = mod(texture2D(backbuffer, vec2(gl_FragCoord.x,gl_FragCoord.y)/resolution) + vec4(0.1, 0.03, 0.01, 0.0), vec4(1.0, 1.0, 1.0, 0.0));
	
	gl_FragColor = vec4(color);
}