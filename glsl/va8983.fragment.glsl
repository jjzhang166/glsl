// fuck that shit.

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co){
	return fract(sin(dot(co, vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	vec2 point = resolution/2.0;
	vec2 dist = gl_FragCoord.xy - point;

	vec3 color = vec3(abs(sin(time*0.1)), 0.5, abs(cos(sin(time*53.0))));
     	float intensity = pow(3.0/(0.01+length(dist)), 2.0);

	vec3 finalColor = vec3(color*intensity*mod(gl_FragCoord.x, 20.0)*mod(gl_FragCoord.y, 20.0)*mod(gl_FragCoord.y, 2.0)*mod(gl_FragCoord.x, 2.0));
	finalColor += rand(position+time)*0.09;

	gl_FragColor = vec4(finalColor, 0);
		
}