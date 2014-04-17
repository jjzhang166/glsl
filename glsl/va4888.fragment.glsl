#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy;
	vec2 nmouse = mouse.xy*resolution.xy;
	vec3 color = vec3(0,0,0);
	if (distance(position,nmouse) < cos(time)*200.0) {//from biggest to smallest
		color = vec3(sin(time),cos(time),1);
	}
	if (distance(position,nmouse) < cos(time)*190.0) {
		color = vec3(1,sin(time),cos(time));
	}
	if (distance(position,nmouse) < cos(time)*180.0) {
		color = vec3(cos(time),1,sin(time));
	}
	if (distance(position,nmouse) < cos(time)*170.0) {
		color = vec3(sin(time),cos(time),1);
	}
	if (distance(position,nmouse) < cos(time)*160.0) {
		color = vec3(1,sin(time),cos(time));
	}
	if (distance(position,nmouse) < cos(time)*150.0) {
		color = vec3(cos(time),1,sin(time));
	}
	if (distance(position,nmouse) < cos(time)*140.0) {
		color = vec3(sin(time),cos(time),1);
	}
	if (distance(position,nmouse) < cos(time)*130.0) {
		color = vec3(1,sin(time),cos(time));
	}
	if (distance(position,nmouse) < cos(time)*120.0) {
		color = vec3(cos(time),1,sin(time));
	}
	if (distance(position,nmouse) < cos(time)*110.0) {
		color = vec3(sin(time),cos(time),1);
	}
	if (distance(position,nmouse) < cos(time)*100.0) {
		color = vec3(1,sin(time),cos(time));
	}
	if (distance(position,nmouse) < cos(time)*90.0) {
		color = vec3(cos(time),1,sin(time));
	}
	if (distance(position,nmouse) < cos(time)*80.0) {
		color = vec3(sin(time),cos(time),1);
	}
	if (distance(position,nmouse) < cos(time)*70.0) {
		color = vec3(1,sin(time),cos(time));
	}
	if (distance(position,nmouse) < cos(time)*60.0) {
		color = vec3(cos(time),1,sin(time));
	}
	if (distance(position,nmouse) < cos(time)*50.0) {
		color = vec3(sin(time),cos(time),1);
	}
	if (distance(position,nmouse) < cos(time)*40.0) {
		color = vec3(1,sin(time),cos(time));
	}
	if (distance(position,nmouse) < cos(time)*30.0) {
		color = vec3(cos(time),1,sin(time));
	}
	if (distance(position,nmouse) < cos(time)*20.0) {
		color = vec3(sin(time),cos(time),1);
	}
	if (distance(position,nmouse) < cos(time)*10.0) {
		color = vec3(1,sin(time),cos(time));
	}
	gl_FragColor = vec4( color, 1.0 );

}