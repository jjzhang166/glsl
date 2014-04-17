#ifdef GL_ES
precision mediump float;
#endif
mat2 rotation;
uniform float time;

void main( void ) {

	
	 vec2 pos = mod(gl_FragCoord.xy / sin (sin(time) - tan (time) * cos (time) * sin (time * time)), vec2(90.0, 80.0)) - vec2(25.0);
	float dist_squared = dot(pos, pos);
	
	if ((dist_squared > 5700.0) || (dist_squared < 100.0))
		discard;
	gl_FragColor = (dist_squared < 1970.0) 
		? vec4(.970 * cos (time), .90 * sin (time), .90, 9.0)
		: vec4(.900, .20, .40, 100.0);
	
}