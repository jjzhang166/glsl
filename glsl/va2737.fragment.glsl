#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;

void main( void ) {
	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	vec3 c = vec3(0.0);
	if(p.y < 0.3333333333333333333333)
		c = vec3(0.2, 0.2, 1.0);
	else if(p.y > 0.3333333333333333 && p.y < 0.666666666666666666666666) 
		c = vec3(1.0, 1.0, 1.0);
	else
		c = vec3(1.0, 0.2, 0.2);
	gl_FragColor = vec4( c, 1.0 );
}