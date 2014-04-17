#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = gl_FragCoord.xy / resolution.xy;

	float r = tan(sin( (p.y + time*0.04) * 40.0) + sin( (p.x - time*0.04) * (time*0.05)));
	float g = tan(sin( (p.y - time*0.04) * 40.0) + sin( (p.x - time*0.04) * (time*0.05)));
	float b = tan(sin( (p.y + time*0.04) * 40.0) + sin( (p.x + time*0.04) * (p.x*10.0)));
	
	gl_FragColor = vec4( vec3( r, g, b), 1.0 );

}