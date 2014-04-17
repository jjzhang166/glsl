#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//random colors using modulo 
//needs some time to get warmed up :D
//in fullscreen and with hidden code it looks like your computer is dying

void main( void ) {

	gl_FragColor = vec4( vec3( mod(time,sin(time*0.7)),mod(time,sin(time*0.2)),mod(time,sin(time*0.3))) , 1.0 );

}