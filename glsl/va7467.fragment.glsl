#ifdef GL_ES
precision mediump float;
#endif

//penna triptoy

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy );

	vec2 p = normalize(position);
	
	float color = 0.0;
	
	float pp = dot(position, position);
	color += 0.5;
	color *= fract(sin(pp / time * 3.0));
	
	
	
	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}