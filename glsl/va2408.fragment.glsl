#ifdef GL_ES
precision mediump float;
#endif
////////////////////////////////////////
// For use with resolution set to 0.5 //
////////////////////////////////////////
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	//vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	vec2 pos = gl_FragCoord.xy;
	vec3 color = vec3(0.0,0.0,0.0);
	float x = pos.x - (resolution.x/0.2);
	float y = pos.y - (resolution.y/0.2);
	color = vec3(sin((time*pos.x*10.0)/2000.0)/4.0+0.5);
	color += vec3(sin((time*pos.y*10.0)/2000.0)/4.0+0.5);
	if (mod(pos.x, 60.0) > 0.5 && mod(pos.y, 60.0) > 0.5)
		color = vec3(0.6);

	 

	gl_FragColor = vec4( color, 1.0);

}