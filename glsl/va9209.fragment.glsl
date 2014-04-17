#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
        float aspect = resolution.x / resolution.y;
	position.x *= aspect;
	
	float color = 0.0;
	float color2 = 0.0;
	//float dist_x = abs(position.x - (log(cos(time)) * 0.25 + 0.5*aspect));
	float dist_x = abs(position.x - (sin(sin(sin(cos(time)))) * 0.25 + sin(0.5*aspect)));
	float dist_y = abs(position.y - (log(cos(time + 3.14/2.0)) * 0.25 + 0.75));
	float dist_h = sqrt(dist_x * dist_x + dist_y * dist_y);
	
	//if ( dist_x < 0.02 && dist_y < 0.02 ) color = 1.0;
	if ( dist_h < 0.2 ) color2 = (0.2 - dist_h) * 10.0;

	gl_FragColor = vec4( color2, color2, 0.0, 1.0 );

}