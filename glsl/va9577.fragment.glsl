//Coded by T_S/RTX1911
//@T_SRTX1911 @rtx1911
//REAL TiME XPRESS "RTX1911" demo divsion
//Best view in 1
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );

	float sync;
	
	if(sin(time * 0.25) > 0.0){
		sync = sin(time * 0.25) + 1.0;
	}else{
		sync = -sin(time * 0.25) + 1.0;
	}
	vec3 col = vec3(mod(floor(p.x * 10.0) + floor(p.y * 10.0), sync), 0.0, 0.0);
	
	gl_FragColor = vec4( col, 1.0 );
	gl_FragColor *= mod(gl_FragCoord.y, 2.0) + sin(gl_FragCoord.y * 0.05 + sin(time * 0.5) * 20.0) * 0.075;
	gl_FragColor *= mod(gl_FragCoord.x, 2.0) + cos(gl_FragCoord.x * 0.05 +cos(time * 0.5) * 20.0) * 0.075;
}