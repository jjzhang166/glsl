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

	vec2 pos = gl_FragCoord.xy;
	vec2 m = mouse * resolution.xy;
	
	float d = distance(m, pos);
	if (d < 200.0) {
		float a = (200.0 - d) / 500.0; 
		pos /= (m - pos) * a;
	}
	
	vec3 color = vec3(1.0,1.0,1.0);
	color += vec3(sin((time*pos.x*10.0)/2000.0)/4.0+0.5);
	color += vec3(sin((time*pos.y*10.0)/2000.0)/4.0+0.5);
	if (mod(pos.x, 60.0) > 0.5 && mod(pos.y, 60.0) > 0.5)
		color *= vec3(0.6) / 2.0;

	 

	gl_FragColor = vec4( color, 1.0);

}