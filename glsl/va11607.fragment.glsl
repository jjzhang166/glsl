#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec2 coolball;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}
void main( void ) {

	float blue;


	coolball.y = 127.0 + sin(time)*30.0;
	float green;
	green = coolball.y/gl_FragCoord.y;
	
	vec2 rando;
	rando.x = 0.0;
	rando.y = -127.0 + sin(time*0.03)*3.0;
	blue = rand(rando/gl_FragCoord.y);
	
	
	
	gl_FragColor = vec4(green/2.0,green,blue,1.0) ;

}