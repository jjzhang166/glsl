#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float timeScale = .1;


void main( void ) {
	float cycle = fract(time*timeScale*.5);
	cycle *= cycle;
	
	vec2 grid = mouse.y * resolution / vec2(cos(6.28*cycle*resolution.x),sin(6.28*cycle*resolution.y)) ;
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy * grid ) - vec2(cycle,0);

	float color = 0.0;
	
	if ( mod(position.y,2.0) < 1.0 ) {
		if ( fract(position.x) < cycle ) color = 1.0;
	} else {
		if ( fract(position.x) > cycle ) color = 1.0;
	}
	
	if ( mod( floor(time*timeScale), 2.0) < 1.0 ) color = 1.0 - color;
		
	gl_FragColor = vec4( color, color, color, 1.0 );

	//I can get purples and greens to show up if I set the resolution to .5 and move slowly...
}