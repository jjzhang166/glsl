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

	float color = distance(position, vec2((cos(time*0.85)+0.0)*1.5, 0.5)) * 1.0;
	
	vec3 finalColor = vec3(1.0, 1.0 - sin(sin(cos(time))), 1.0 - cos(color));
	finalColor += rand(position+time)*0.55;
	finalColor /= 20.0;
	finalColor *= mod(gl_FragCoord.y, 2.0);

	gl_FragColor = vec4( vec3(finalColor), 1.0 );
}