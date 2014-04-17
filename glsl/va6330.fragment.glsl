// <http://www.niksula.hut.fi/~hkankaan/Homepages/metaballs.html>

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	float sum = 0.0;
	float size = 72.0;
	float r = 35.0;
	float g = 1.0;
	for (int i = 0; i < 22; ++i) {
		vec2 position = resolution / 2.0;
		position.x += sin(time*0.5 + 10.0 * float(i)) * 50.0;
		position.y += cos(time*0.5+ 5.0 * float(i)) * 50.0;
		
		float dist = length(gl_FragCoord.xy - position);

		sum += size / pow(dist, g);
	}
	
	vec3 color = vec3(0,0,0);
	if (sum>r) color = vec3(r/sum,r/sum,1);

	
	gl_FragColor = vec4(color, 1);
}