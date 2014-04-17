#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {
	vec2 distanceVector = gl_FragCoord.xy - resolution/2.;
	float angle = atan(distanceVector.x, distanceVector.y) + time * .12 * (1. - 0.0001 * length(distanceVector));
	float isSolid = clamp(sin(angle*2.0 + 4. * sin(time * 6. - length(distanceVector) * 0.0095)) * 100.0, 0.97, 1.0);
	gl_FragColor = vec4(234.0/255.0, 228.0/255.0, 218.0/255.0, 1.0) * isSolid;
}