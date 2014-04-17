// @timb

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
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	
	float r = rand(vec2(position.x, position.y));
	
	gl_FragColor = vec4( r+sin(time), r+sin(time/2.0), r+sin(time/3.0),  1.0);
	
}