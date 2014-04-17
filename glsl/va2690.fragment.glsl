#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	vec3 color = vec3(0.1, 0.3, 0.1)*vec3(rand(position+time/1000.));

	float d2 = 1.;
	
	if (0.1 < d2 && d2 < 0.105)
	  color += vec3(0,0.2,0);
	
	gl_FragColor = vec4( color, 1.0 );
	
}