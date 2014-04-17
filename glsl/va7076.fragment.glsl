#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {


	vec4 color;
	if(mouse.x<0.5){
		color=vec4(1.0,0.0,0.0,1.0);
	}else
	{
		color=vec4(0.0,1.0,0.0,1.0);
	}
	if(mouse.y<0.5){
		color+=vec4(0.0,0.0,1.0,1.0);
	}
	gl_FragColor = color;

}