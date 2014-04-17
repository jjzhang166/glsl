#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float square(vec2 position2, vec2 center, float radius) {
	vec2 d = position2 - center;
	if(abs(d.x)<radius && abs(d.y)<radius)
		return 1.0;
	return 0.0;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	vec2 position2 = ( gl_FragCoord.xy / resolution.xy ) - mouse;
	
	
	
	vec3 bandeVerticales = vec3(1.0, 0.0, 1.0) * sin(position.x * 50.0) * sin((position.y * 50.0) + 10.0);
	vec3 bandeHorizontales = vec3(0.0, 1.0, 0.0) * sin(position.y * 50.0) * sin(position.x * 50.0);
	
	
	
	float color = 1.0;
	
	float mavar = ((sin(time*1.5)+.7)*0.05)+0.05;
	
	if (distance(position, mouse) > mavar)  {
		
		color = 0.0;
	}

	//color += square(position2, vec2(cos(time) * 0.2, sin(time)*0.2), 0.03);
	
	float orbit= 2.0 * mavar;
	color += square(position2, vec2(cos(time) * orbit, sin(time)*orbit), (sin(time*5.0)+1.5)*0.015);
	
	color += texture2D(backbuffer, position)*.9;
			
	gl_FragColor = vec4( vec3(color), 1.0 );
	
	
	
}

