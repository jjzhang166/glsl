#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
//Matrix - Armageddon! by Unknown  (and just shrunk to tiny version by @danbri, for learnin')
void main( void ) {
	float speed=0.1;
	gl_FragColor = vec4((resolution.y-gl_FragCoord.y)*(2.0/resolution).y*0.2,
			    tan(0.1*(cos(speed*time)*gl_FragCoord.x+sin(3.0*speed*time)*gl_FragCoord.y)),// mod(gl_FragCoord.y+ time, cos(gl_FragCoord.x)+0.004)*.5,
			    sin(1.0*(cos(time)*gl_FragCoord.x+sin(time)*gl_FragCoord.y)) , // sin(gl_FragCoord.x+10.0*time) , //*(2.0/resolution).x*0.2,
			    1.);}