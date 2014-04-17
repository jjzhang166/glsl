#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xx);
	vec3 col = vec3(0.0);
	
	for (float ix = 0.0; ix < 81.0; ix++) {
		vec2 c = vec2(ix * 0.0125, resolution.y/resolution.x*0.5 + cos(time * (ix * 0.05 + 1.0))*(resolution.y/resolution.x*0.5));
		if (distance(c, pos) < 0.01)
			col = vec3(1.0);
	}

	gl_FragColor = vec4( col, 1.0 );

}