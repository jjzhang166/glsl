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
	position.x += time;
	float r = rand(position) / 1.5;		
	gl_FragColor = vec4(r, r, r, 1.0);
}