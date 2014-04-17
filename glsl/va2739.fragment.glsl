#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;

void main( void ) {
	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	vec3 c = vec3(0.807, 0.168, 0.215);
	if(p.x < 0.333)
		c = vec3(0, 0.572, 0.274);
	else if(p.x > 0.333 && p.x < 0.666) 
		c = vec3(1.0, 1.0, 1.0);
	gl_FragColor = vec4( c, 1.0 );
}