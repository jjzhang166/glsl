#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy;// / resolution.xy ) + mouse / 4.0;
	float radio_pacman = 60.0;
	float angulo;
	vec2 centro = resolution.xy/2.0;
	
	vec2 horizontal;
	horizontal.x = resolution.x;
	horizontal.y = resolution.y/2.0;
	horizontal = normalize(horizontal);
	
	vec2 orientacion = normalize(position - centro);
	
	angulo = acos(dot(horizontal, orientacion));
	
	if((distance(position,centro) < radio_pacman) && angulo > 0.50)
	{
		gl_FragColor = vec4( 1.0,1.0,0.0, 1.0 );
	}
	else
	{
		gl_FragColor = vec4( 0.0,0.0,0.0, 1.0 );
	}
}