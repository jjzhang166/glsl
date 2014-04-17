// Thanks for picking up my hack! I wanna see games here :) --@rianflo

//how to have persistent global "variables" in glsl
//due to the parallel nature of shaders, you can't have globals in the "normal" way
//however, there is a "loophole": the screen itself is persistent thanks to the back buffer

//TODO: make this into pong or some simple game
precision highp float;


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

#define MEMORY_LOCATION vec2(0.5,0.5)

void main( void ) {

	vec2 pos=gl_FragCoord.xy / resolution.xy;

	vec3 color;
	
	vec4 state = texture2D(backbuffer, MEMORY_LOCATION);
	vec2 ball=state.rg;
	
	vec2 dir=normalize(mouse-ball);
	//stop it from spazzing
	if(distance(mouse,ball)>0.01){
		ball+=dir*0.005;
	}
	
	if(distance(pos,ball)<0.1){
		color.r=1.;
	}
	
	//save the variable to the screen
	if (distance(pos,MEMORY_LOCATION) < 0.1) {
		gl_FragColor = vec4(ball,0.,0.);
	}
	//if we arent "writing to memory", draw whatever
	else{
		gl_FragColor = vec4( color, 1.0 );
	}

}