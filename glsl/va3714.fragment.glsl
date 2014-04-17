// by rotwang

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

	float aspect = resolution.x / resolution.y;
	vec2 unipos = ( gl_FragCoord.xy / resolution );
 	vec2 pos = unipos*2.0-1.0;//bipolar
	pos.x *= aspect;

	float f = 16.0;
	float x = sin(pos.x*f);
	
	float sa = max(x,0.0);
	
	sa *= step(0.0, pos.y);
	sa *= step(pos.y, 0.66* rand(pos.yy));
	
	vec3 clr = vec3(sa*0.33, sa*0.66, sa*1.0);
	
	
	gl_FragColor = vec4( clr, 1.0 );
	
}