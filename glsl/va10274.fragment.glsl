#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {
	float rings = 1000.0;
	float speed = 5.0;
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
        float aspect = resolution.x / resolution.y;
	position.x *= aspect;
	float dist_x = cos (position.x - 1.0);
	float dist_y = cos (position.y - 0.5);
	float dist_h = sin (dist_x * dist_x + dist_y * dist_y);
	float color = sin (rings * dist_h + (time * speed));
	gl_FragColor = vec4 (color, color, color, 1);
}