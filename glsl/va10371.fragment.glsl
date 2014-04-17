// basic outline shader

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

float shape(vec2 position) {
float color = step(length(vec2(0.5)-position), 0.15);
	color += step(length(vec2(0.18*cos(time),0.3*sin(time))+vec2(0.5)-position), 0.1);
	color += step(length(vec2(0.4*cos(time),0.4*sin(time))+vec2(0.5)-position), 0.1);
	color += step(length(vec2(0.2*cos(time),0.4*sin(time))+vec2(0.5)-position), 0.1);

	color = min(1.0, color);
	return color;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	// base shape
	float color = shape(position);
	
	// compute deltas (naive edge detect)
	float dx = color - shape(position-vec2(2.0, 0.0)/resolution);
	float dy = color - shape(position-vec2(0.0, 2.0)/resolution);
	float diff = length(vec2(dx,dy));
	
	// outline
	vec3 outColor = mix(vec3(color, color, 0.0), vec3(1.0, 0.0, 0.0), diff);

	gl_FragColor = vec4( outColor, 1.0 );

}