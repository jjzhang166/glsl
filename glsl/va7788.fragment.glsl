#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float rand(float c){
    return fract(sin(dot(vec2(c, c) ,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {

//	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float r = rand(position);
	float g = rand(r);
	float b = rand(g);
	gl_FragColor = vec4(r, g, b, 1.0);
}