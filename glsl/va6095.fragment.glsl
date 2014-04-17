#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const float MAXITER = 1000.0;

void main( void ) {
	float scale;
	//scale = 10.0 + abs(10.0 - mod(time, 20.0)); // triangle
	scale = 5001.0 + 5000.0 * sin(time / 10.0); // sine
	//scale = floor(mod(time, 2.0)); // rectangle
	
	vec2 position = gl_FragCoord.xy;
	position = vec2(position.x/scale + resolution.x * mouse.x * (1.0 - 1.0 / scale), position.y/scale + resolution.y * mouse.y * (1.0 - 1.0 / scale));
	position = vec2(3.0 / resolution.x * position.x - 2.0, 2.0 / resolution.y * position.y - 1.0);
	
	vec2 pos0 = position;
	for(float i=0.0; i < MAXITER; i+=1.0){
		position = vec2(position.x*position.x - position.y*position.y, 2.0*position.x*position.y) + pos0;
		if(dot(position,position) > 4.0){
			gl_FragColor = vec4( mod(MAXITER / i, 100.0)/100.0, mod(MAXITER / i, 1000.0)/1000.0, mod(MAXITER / i, 10.0)/10.0, 1.0);
			break;
		}else if( i == MAXITER - 1.0 ){
			gl_FragColor = vec4( 0.0, 0.0, 0.0, 1.0);
		}
	}
	
	//if(resolution.y * mouse.y < gl_FragCoord.y)gl_FragColor = vec4(0.0,1.0,1.0,1.0);
}