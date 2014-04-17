#ifdef GL_ES
precision mediump float;
#endif



uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform float random;

float pRandom(vec2 position){
	return sin(position.y)/cos(position.y) * sin(position.x)*cos(position.x)*sin(time);
}

void main( void ) {

	vec2 position = gl_FragCoord.xy;
	gl_FragColor = vec4(pRandom(position),0.0,0.0,0.0);
}

