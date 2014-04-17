#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;



void main( void ) {
	/*
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 100.0;

	float intensity = tan(time*1.8 - 60.0*distance(position,mouse)) + position.x*10.0 + position.y*10.0);
	vec3 color = intensity *  vec3(0., 0.0, .5);
	
	float intensity2 = cos(position.y * 2.1);
	vec3 color2 = intensity2 + vec3 (0.5, 0., 0.5);
	
	gl_FragColor = vec4(color+color2, 1.0 );
	*/
	
	vec2 pos = (resolution.xy * .5);
	vec2 mou = ( gl_FragCoord.xy / resolution.xy ) + mouse / 100.0;
	float red = (distance(pos.xy,gl_FragCoord.xy)) * .1;
	float blue = (distance(mou.xy, gl_FragCoord.xy)) * .1;
	float green =  cos(gl_FragCoord.y);
	gl_FragColor = vec4(red, green, blue, 1.0);
	
	

}