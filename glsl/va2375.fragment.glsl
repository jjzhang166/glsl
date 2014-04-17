#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	
	float x = position.x - mouse.x;
	float y = position.y - mouse.y;
	float dist = sqrt(x*x + y*y);
	dist = cos(dist*100.0*time);
	float val_x = position.x;
	float val_y = position.y;
	float add = val_x + val_y;
	gl_FragColor = vec4( vec3(cos(0.71*time), dist, sin(time*1.5)), 1.0);

}