#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

const float pi = 3.14159265;

float circleRadius = .025;
float circulationRadius = .025;
vec3 color = vec3( .0, .0, .0);
float factor = 1.0;


vec2 circle( vec2 p) {
	p.x -= sin(mod(time * factor, 2.0 * pi)) * circulationRadius; 
	p.y -= cos(mod(time * factor, 2.0 * pi)) * circulationRadius;
	
	
	if( length(p) < circleRadius) {
		color.x =  sin(mod(time * factor, 2.0 * pi));
		color.y =  cos(mod(time * factor, 2.0 * pi));
		color.z =  1.0;
	}
	return p;
}


void main( void ) {
	
	vec2 position = ( gl_FragCoord.xy/resolution );
	position.x *= resolution.x/resolution.y;
	
	
	vec2 p = position;
	p.x -= 1.0;
	p.y -= .5;
	
	for(float i = 0.0; i < 10000.0; i++) {
		p = circle( p );
		factor += .01;
		circulationRadius *= 1.015;
		if( mod( i, 5.0) == 0.0) {
			circleRadius *= .95;
		}
	}
	
	color += texture2D(backbuffer, gl_FragCoord.xy / resolution.xy).rgb * .8;
	
	
	gl_FragColor = vec4( color, 1.0 );

}


