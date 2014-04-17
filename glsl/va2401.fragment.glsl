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
	float x = pos.x - (resolution.x/2.0);
	float y = pos.y - (resolution.y/2.0);
	color = vec3(sin((time*pos.x*100.0)/7500.0)/4.0+0.5);
	color += vec3(sin((time*pos.y*100.0)/7500.0)/4.0+0.5);
	if (mod(pos.x, 40.0) > 0.5 && mod(pos.y, 40.0) > 0.5)
		color = vec3(0.5);
	/*if (pos.x < 100.0 && pos.y < 100.0)
		;
	else
		color = vec3(0.0);*/
	 
	if (y > sin((x+time*-50.0)/100.0)*100.0 )
		color += vec3(0.0,0.0,1.0);
	if (abs(y-(sin((x+time*1000.0)/100.0)*100.0)) < 5.0)
		color *= vec3(0.4, 0.4, 2.0);
	gl_FragColor = vec4( color, 1.0);

}