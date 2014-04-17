#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy );
	
	float line_thick = 1.0;
	float half_line_thick = 0.5;
	float amp = resolution.y * 0.15;
//	time = 1.0;
	float o1 = (
		sin( position.x *0.025 + time*4.0) * 0.5 
		+ cos(position.x * 0.033 + time * 3.0) * 0.5
	) * amp;
	
	float o2 = (
		sin( position.x *0.065 + time*4.3) * 0.5 
		+ cos(position.x * 0.05 + time * 3.7) * 0.5
	) * amp;
	o1 = sin(position.x *0.05) * amp;
	if(position.y > resolution.y*0.5 - 3.0 + o1 && position.y < resolution.y*0.5 + o1){
		gl_FragColor = vec4( 1.0,0.0,0.0, 1.0 );
	}else if(position.y > resolution.y*0.5 - 3.0 + o2 && position.y < resolution.y*0.5 + o2){
		gl_FragColor = vec4( 1.0,0.0,1.0, 1.0 );
	}else{
		gl_FragColor = vec4( 0.0,0.0,0.0, 0.0 );	
	}

}