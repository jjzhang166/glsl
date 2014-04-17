#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float rings = 400000.0; // Not the exact amount of rings, but higher value means more rings
	float speed = 3.0;
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
        float aspect = resolution.x / resolution.y;
	position.x *= aspect;
	float dist_x = abs(position.x - 1.0);
	float dist_y = abs(position.y - 0.5);
	float dist_h = sqrt(dist_x * dist_x + dist_y * dist_y);
	
	float color_r = sin(rings*dist_h + (time*3.0));
	float color_g = sin(rings*dist_h + (time*10.));
	float color_b = sin(rings*dist_h + (time*1.0));
	
	
	gl_FragColor = vec4( color_r, color_g, color_b, 1.0 );

}