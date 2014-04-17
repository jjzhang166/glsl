//Coded by T_S / RTX1911
//REAL TiME XPRESS "RTX1911" Demo division
//www.rtx1911.nrt
//@rtx1911

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	p.x *= (resolution.x / resolution.y);
	//Write your Code here (Begin)
	
	
	p.x += time * 0.25;
	p.y += sin(time * 0.25);
	vec3 col = vec3(1.0);
	col *= vec3(p.x, p.y, 1.0);
	col *= vec3(smoothstep(0.4, 0.6, max(abs(fract(p.x * 8.0 - 0.5 * mod(floor(8.0 * p.y), 2.0)) - 0.5), abs(fract(8.0 * p.y) - 0.5))));
	
	
	//vec3 col = vec3(smoothstep(0.37, 0.35, length(fract(sin(time * 0.25) * 4.0 * p.xy) - 0.5)));
	
	
	
	gl_FragColor = vec4( col, 1.0 );
	
	
	//End Code
	gl_FragColor *= mod(gl_FragCoord.y, 3.0);
}