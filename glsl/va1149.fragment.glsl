#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
//Matrix - Armageddon! by Unknown  (and just shrunk to tiny version by @danbri, for learnin')
void main( void ) { gl_FragColor = vec4((resolution.y-gl_FragCoord.y)*(2.0/resolution).y*0.2,-mod(gl_FragCoord.y+ time, cos(gl_FragCoord.x)+0.004)*.5,gl_FragCoord.y*(2.0/resolution).y*0.2,1.);}