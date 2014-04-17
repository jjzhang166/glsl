#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

       vec2 position = ( gl_FragCoord.xy / resolution.xy ) + time;

       float rand = mod(fract(sin(dot(position, vec2(12.9898,78.233))) * 43758.5453), 1.0);

       gl_FragColor = vec4( rand, rand, rand, 1.0);

}