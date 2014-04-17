#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

bool near(float i, float t, float e){
	return i < t+e && i > t-e;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy );
	
	float line_thick = 1.0;
	float half_line_thick = 0.5;
	float amp = resolution.y * 0.15;
//	time = 1.0;
	float o1 = (
		sin( position.x *0.005 + time*1.0) * 0.5 
		+ cos(position.x * 0.0033 + time * 2.0) * 0.5
	) * amp;
	
	float o2 = (
		sin( position.x *0.0065 + time*3.3) * 0.5 
		+ cos(position.x * 0.005 + time * 2.7) * 0.5
	) * amp*0.8;

	float o3 = (
		cos( position.x *0.004 + time*1.3) * 0.33 
		+ cos(position.x * 0.005 + time * 2.5) * 0.33
		+ sin( position.x *0.0065 + time*1.3) * 0.33
	) * amp*0.6;

	for(float j = 0.0; j < 1.0; j++){
	
		if(near(position.y,o1 + resolution.y*0.5 + j*50.0 ,3.75)){
			gl_FragColor = vec4( 1.0,0.0,0.0,1.0 );		
		}
	
	
		if(near(position.y,o2 + resolution.y*0.5 + j*50.0,7.75)){
			gl_FragColor = vec4( 0.0,0.0,1.0, 1.0 );		
		}
	
	
	
		if(near(position.y,o3 + resolution.y*0.5 + j*50.0,2.75)){
			gl_FragColor = vec4( 0.0,1.0,0.0, 1.0 );		
		}
	
	}
}

