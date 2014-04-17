#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Hm?

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy ) * (100. * time / 2.0);
	/*	if ((sin(pos.x) > 0.)&&(sin(pos.y) >0.)){
			gl_FragColor=vec4(1.0, 1.0, 1.0, 1.0);
		}
		if ((sin(pos.x) < 0.)&&(sin(pos.y) < 0.)){
			gl_FragColor=vec4(1.0, 1.0, 1.0, 1.0);
		}
		if ((sin(pos.x) < 0.)&&(sin(pos.y) > 0.)){
			gl_FragColor=vec4(0.0, 0.0, 0.0, 1.0);
		}
		if ((sin(pos.x) > 0.)&&(sin(pos.y) < 0.)){
			gl_FragColor=vec4(0.0, 0.0, 0.0, 1.0);
		}*/
	
	gl_FragColor = (mod(pos.x / 20.0, 1.0) > 0.5 ^^ mod(pos.y / 20.0, 1.0) > 0.5) ? vec4(1.0) : vec4(0.0);
}