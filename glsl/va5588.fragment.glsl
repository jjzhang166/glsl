#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) ;

	float color = 0.0;

	vec2 light = vec2(0.5, 0.5);
	
	float dist = distance(position,vec2(sin(time)*0.4, (cos(time*2.0)*2.0*0.1)+0.2));
	
	if(dist > 0.05) {
		vec2 _dimNor = vec2(dist,dist)-light;
		color = 0.5*_dimNor.x*_dimNor.y;
	}
	else
	{
		color = 1.0;
	}

	gl_FragColor = vec4( color * (color-color*0.2), color, color, 1.0 );

}