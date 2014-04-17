#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;

void main( void ) {
	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	vec3 c = vec3(0.666, 0.082, 0.098);
	if(p.y > 0.25 && p.y < 0.75)
		c = vec3(0.945, 0.749, 0.0);
	gl_FragColor = vec4( c, 1.0 );
}