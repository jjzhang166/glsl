// fuck that shit

// black to white transition

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - 0.5;

	float delta = mod(time*1.0, 3.0)-1.5;

	float intensity = tan(sin(delta + position.x*0.5));
	vec3 color = intensity * vec3(1.0, 0.5, 0.8);
	
	float intensity2 = cos(position.y * 9.5);
	vec3 color2 = intensity2 * vec3(0.0, 0.5, 0.3);

	color.r *= mod(gl_FragCoord.y, 2.0);
	color2.b *= mod(gl_FragCoord.y, 2.0)*2.0;

	gl_FragColor = vec4((color+color2)*(sin(delta)*3.0+4.0), 1.0 );

}