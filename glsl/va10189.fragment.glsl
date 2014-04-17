#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float wave(vec2 pos, float angle) {
	vec2 dir = vec2(cos(angle), sin(angle));
	return cos(dot(pos, sin(dir)));
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ); //+ mouse / 4.0;

	

    	vec2 p = (position - 0.5) * 12.;
	
    	float brightness = 0.;
    	for (float i = 1.; i <= 11.; i++) {
        	brightness += wave(p, time / i);
    	}
	brightness += smoothstep(sin(time / 4.0), cos(time / 2.0), time / 10.0);
    	gl_FragColor.rgb = vec3(brightness);
    	gl_FragColor.a = 1.;
}