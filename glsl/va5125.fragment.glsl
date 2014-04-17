#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {

	vec2 p = - 1.0 + 2.0 * ( gl_FragCoord.xy / resolution.xy );
	p.x *= resolution.x/resolution.y;
	vec3 col = vec3(0.0);
	
	p += vec2(sin(time*5.0), cos(time))*0.3;

	float r = length(p);
	float t = time;
	
	if(r < 0.1)
	col = vec3((1.0-r), 0.0 ,0.0);
	
	col = mix(col, texture2D(backbuffer, gl_FragCoord.xy / resolution.xy).rgb, 0.90);
	gl_FragColor = vec4( col, 1.0 );

}