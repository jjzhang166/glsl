#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy ) * (100.);
		if ((sin(pos.x) > 0.)&&(sin(pos.y) >0.)){
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
		}
}