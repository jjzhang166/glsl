#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void ) {

	vec2 position = (gl_FragCoord.xy/resolution.xy) * 2. * sin(time);
	
	position*=2.0;
	position-=vec2(1.0,1.0);
	
	position.y*=(resolution.y/resolution.x);
	
	position*=5.0;
	
	//position.x *= 0.1;
	//position.y *= 0.1;
	
	//float col = mod(position.x*position.x+position.y*position.y,1.0);
	
	float col = mod((2.0*position.x+position.y)*(2.0*position.x-position.y)*(position.x+2.0*position.y)*(position.x-2.0*position.y),1.0);

	
	gl_FragColor = vec4(col, col, col, col);
	
	
	//gl_FragColor = vec;

}

