#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

	
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}


void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float color = 0.0;
	color += 1.0 * sin(gl_FragCoord.x + 20.0 * sin(time));
	color += 0.5 * cos(gl_FragCoord.y + 10.0 * cos(time));

	float f = distance(gl_FragCoord.xy, 
			   vec2(gl_FragCoord.x , 
				resolution.y/2.0 + 20.0 * sin(gl_FragCoord.x / 15.0 + time * 5.0 + rand(gl_FragCoord.xy))));
	if (f < 10.0) {
		f = 1.0 - f / 10.0;
		gl_FragColor = vec4(f,
				    pow(f + sin(time*4.0 + gl_FragCoord.x/20.0)/3.0,2.0),
				    pow(f,0.5) + 0.25 * sin(time*5.0 +10.0),
				    1.0);
	} else {
		gl_FragColor = vec4(0.0,0.0,0.0,0.0);
	}

}

