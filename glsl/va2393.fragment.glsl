// Baby steps, experimenting around. Don't really expect to do anything wonderful


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

float rand(vec2);

void main( void )
{

	gl_FragColor = vec4(rand(gl_FragCoord.xy), rand(gl_FragCoord.xz), rand(gl_FragCoord.yz), 1.0);
}

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453 * sqrt(time));
}