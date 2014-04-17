#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	

	vec2 coord = gl_FragCoord.xy;
	
	//coord.x = mod(coord.x, 10.0);
	coord.y += cos(5.5 + coord.x * time / 120.0) + 2.0 * sin((coord.x + time) / 10.0);
	coord.x /= (10.0 * (cos(time) + 2.0));

	float color = 0.0;
	color += step(.95, sin(coord.y + cos(time / 100.0 + sin((coord.x + cos(time / 20.0) / 34.0)))));
	
	//color *= sin( time / 10.0 ) * 0.5;

	gl_FragColor = vec4( vec3( color *.5, color * 0.5, color * 0.75 ), 1.0 );
	
	if(mod(gl_FragCoord.y, 20.0) < 10.0 && mod(gl_FragCoord.x, 20.0) < 10.0)
		gl_FragColor += vec4(vec3(0.2), 0.0);

	if((mod(gl_FragCoord.y, 20.0) > 10.0 && mod(gl_FragCoord.x, 20.0) > 10.0))
		gl_FragColor += vec4(vec3(0.2), 0.0);	

}