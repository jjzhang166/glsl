#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform vec4 pos;

void main( void ) {

	float x = gl_FragCoord.x / resolution.x;
	float y = 1.0 - gl_FragCoord.y / resolution.y;
	float period = (time-12.0 * floor(time/12.0));
	float smooth = (sin(time))+2.0;
	
	if (smooth < 1.1) {
		
	}
	
	vec2 n = vec2(x,y*smooth);
	
	vec3 o = vec3(normalize(vec2(4.0*(y+x),smooth)),0);
	gl_FragColor = vec4( o,1);
}