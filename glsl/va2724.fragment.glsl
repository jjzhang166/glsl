#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;

void main( void ) {
	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	vec3 c = vec3(0.0);
	if(p.y < 0.333)
		c = vec3(1.0, 0.8, 0.0);
	else if(p.y > 0.333 && p.y < 0.666) 
		c = vec3(1.0, 0.0, 0.0);
	else
		c = vec3(0.0);
	gl_FragColor = vec4( c, 1.0 );
}