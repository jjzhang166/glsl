#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// testing iso curves

float thing(vec2 pos) {
	pos = max(abs(pos) - .5, .1);
	return length(pos) - 1.0;
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution );
	//vec2 pixel = 1./resolution;
	vec2 world = (position - mouse) * 5.0;
	world.x *= resolution.x / resolution.y;

	float dist = thing(world);

	gl_FragColor = vec4( -dist, dist - 1.0, dist, 1.0 );

	if (abs(dist) < 0.1) {
		gl_FragColor.rgb = vec3(1.0 - abs(dist * 10.0));
	}
}