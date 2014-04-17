#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
void main( void ) {
	vec2 p = (gl_FragCoord.xy / resolution.xy);
	gl_FragColor = vec4(1.0, 0.48, 0.15, 1.0);
	if((p.y > 0.6 && p.y < 0.7) || (p.x > 0.7 && p.x < 0.76))  gl_FragColor = vec4(1.0, 0.9, 0.3, 1.0);
}
