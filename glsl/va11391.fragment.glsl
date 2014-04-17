#ifdef GL_ES
precision mediump float;
#endif
mat2 rotation;
uniform float time;

void main( void ) {

	
	 vec2 pos = mod(gl_FragCoord.xy / sin (time * 3.0)/10.0, vec2(50.0, 50.0));
	float dist_squared = dot(pos, pos);
	
	if ((dist_squared > 570.0) )
		discard;
	gl_FragColor = (dist_squared < 350.0) 
		? vec4(.90 * cos (time), .90 * sin (time), .90, 1.0)
		: vec4(.90, .20, .40, 1.0);
	
}