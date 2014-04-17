#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

varying vec2 surfacePosition;

void main( void ) {
	
	vec3 center = vec3(1.5, 0.0, 0.0 );
	vec3 normal = vec3(0.0, 0.1, 0.0);
	float width = 0.1;
	
	float alpha = radians(30.0);
	
	mat3 proj = mat3(1.0, 0.0, 0.5 * cos(alpha),
			 0.0, 1.0, 0.5 * sin(alpha),
			 0.0, 0.0, 0.0);
	
	vec4 position = vec4(surfacePosition, 0.0, 0.0);
	
	float angle = radians(90.0);
	
	mat4 transformation = mat4(cos(angle), -sin(angle), 0.5 * cos(alpha), 0.0,
			           sin(angle),  sin(angle), 0.5 * sin(alpha), 0.0,
			           0.0       ,  0.0       , 1.0             , 1.0,
				   0.0	     ,  0.0       , 0.0             , 1.0);
	
	vec4 pos = transformation * position;
	
	if (width > abs(pos.x) && width > abs(pos.y) && width > abs(pos.z)) {
		gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
	} else {
		
	
		/*mat2 rotation = mat2(cos(angle), -sin(angle),
				     sin(angle),  cos(angle));
		vec2 borderX = vec2(width, 0.0) * rotation;
		vec2 positionX = vec2(surfacePosition.x, 0) * rotation;*/
		
		/*float intensity = 0.0;
		
		if (length(positionX) < length(borderX)) {
			intensity = 1.0;
		}*/
		
		
		gl_FragColor = vec4( 0.0, 0.0, 0.0, 0.0 );
	}

}