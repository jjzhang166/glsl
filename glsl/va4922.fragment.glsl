#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy )*256.0;
	pos -= 128.0;
	
	float color = 0.0;
	float dist=sqrt(pos.x*pos.x+pos.y*pos.y);
	color += cos(dist-time*16.0);
	gl_FragColor = vec4( vec3( color*(256.0-dist)/dist/2.0, color , 0), 1.0 );

}