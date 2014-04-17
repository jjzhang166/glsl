#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D bbuff;

void main( void ) {

	vec2 pos = gl_FragCoord.xy ;
	vec3 color = vec3(0,0,0);
	
	if(distance(pos, mouse * resolution) < 30.)
	{
		color += vec3(.5, .5, .5);
	}
	
	color += texture2D(bbuff, vec2(10., 10.)).xyz;
	

	gl_FragColor = vec4( color, 1.0 );

}