#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// work in progress

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float c = 0.0;
	
	if (gl_FragCoord.y < resolution.y/2.0 + sin(time*1.0 + gl_FragCoord.x/9.0)*40.0 + sin(time*4.0 + gl_FragCoord.x/10.0)*40.0 + sin(time*6.0 + gl_FragCoord.x/10.0)*40.0) { 
		c = 1.0; 
	}

	gl_FragColor = vec4( vec3( c, c, c ), 1.0 );

}