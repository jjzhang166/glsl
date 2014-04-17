// Stare at this for a while then look at your wall.
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = -1.0 + 2.0 * (gl_FragCoord.xy / resolution.xy);
	vec3 c = vec3(sin(time), sin(time*3.34223), sin(time*1.949382));
	float col = 0.0;
	float S = sin(time);
	float C = cos(time);
	
	for (int i = 0; i < 50; i++) {
		c += p.xyx;
		col += c.x + c.y - c.z;
	}
	gl_FragColor = vec4(sin(col)*0.5 + 0.5);
}