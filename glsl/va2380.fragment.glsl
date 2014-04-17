#ifdef GL_ES
precision mediump float;
#endif
//////////////////////////////////////////////////
// For use with resolution set to 0.5           //
// Really? You guys, why did you simplify it?!? //
// I'm making this one more complicated :)      //
// TRIG FUNCTIONS!                              //
//////////////////////////////////////////////////
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
		color = vec3(0.1);
	/*if (pos.x < 100.0 && pos.y < 100.0)
		;
	else
		color = vec3(0.0);*/
	 
	if (y > sin((x+time*-50.0)/100.0)*100.0 )
		color += vec3(0.0,0.0,0.5);
	if (y < cos((x+time*-90.0)/100.0)*100.0 )
		color += vec3(0.5,0.0,0.0);
	float j = tan((x+time*-140.0)/100.0)*100.0;
	if (y < j )
		color += vec3(0.0,max(1.0-(abs(j-y)*0.01),0.0),0.0);
	if (abs(y-(sin((x+time*50.0)/100.0)*100.0)) < 5.0)
		color *= vec3(0.4, 0.4, 2.0);
	if (abs(y-(cos((x+time*70.0)/100.0)*100.0)) < 5.0)
		color *= vec3(2.0, 0.4, 0.4);
	if (abs(y-(tan((x+time*-170.0)/100.0)*100.0)) < 5.0)
		color *= vec3(0.4, 2.0, 0.4);
	gl_FragColor = vec4( color, 1.0);

}