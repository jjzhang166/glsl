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
	float r = rand(gl_FragCoord.xy);
	
	float v = r*0.2 + 0.5;
	gl_FragColor = vec4(v, v, v, 1.0);
}