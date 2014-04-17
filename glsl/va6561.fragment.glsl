#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co){
    return fract(sin(dot(floor(co.xy) ,vec2(0,1)+tan(time*0.0001)))*500.0);
}

void main( void ) {

	vec2 position = gl_FragCoord.xy - (mouse*resolution);
	float color = rand(position.xy*(0.50 + sin(time)*0.3));
	
	//if (color < 0.5) color = 0.0; else color = 1.0;
	color = (floor(color * 6.0) + 0.2)/7.0;
		
	gl_FragColor = vec4( color, sin(color*time*920.0), tan(color+time*790.0), 1 );

}