//Coded by T_S/RTX1911 @T_SRTX1911
//REAL TiME XPRESS "RTX1911" (www.rtx1911.net)

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float sync;
	
	if(sin(time * 0.25) > 0.0){
		sync = sin(time * 0.25) + 1.0;
	}else{
		sync = -sin(time * 0.25) + 1.0;
	}
	vec3 col = vec3(mod(floor(position.x * 10.0) + floor(position.y * 10.0), sync), 0.0, 0.0);
	
	gl_FragColor = vec4(col, 1.0 );

}