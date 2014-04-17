
#ifdef GL_ES
precision mediump float;
#endif
//need a logo and I got a bumpMap ;)
uniform float time;
uniform vec2 resolution;
void main( void ) {
	vec3 color1 = vec3(0.9, 0.2, 0.2);
	vec3 color3 = vec3(0.9, 0.9, 0.9);
	vec2 point1 = resolution/2.0 + vec2(sin(time*2.0) * 250.0, cos(time*1.0) * 100.0);
	vec2 dist1 = gl_FragCoord.xy - point1;
	float intensity1 = pow(3.0/(0.1+length(dist1)), 2.0);
	gl_FragColor = vec4((color1*intensity1)*mod(gl_FragCoord.x, 10.0)*mod(gl_FragCoord.y, 9.0),1.0);
}