#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co){
    return fract(sin(dot(floor(co.xy) ,vec2(12.9898,78.233)+sin(time*0.000001))) * 43758.5453);
}

void main( void ) {

	vec2 position = gl_FragCoord.xy - (mouse*resolution);
	float color = rand(position.xy*(0.15 + sin(time)*0.1));
	
	if (color < 0.5) color = 0.0; else color = 1.0;

	gl_FragColor = vec4( color, color, color, 1 );

}