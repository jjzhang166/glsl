//Use 0.5

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float y = (gl_FragCoord.y - resolution.y / 2.0) * pow(9.0 - mouse.y * 8.0, sin(time / 2.0)) * sin((gl_FragCoord.x - resolution.x / 2.0) / 2000.0) + time + mouse.x * 10.0;
	float value = floor(mod(y, 4.0));
	gl_FragColor = vec4(sin(y), -sin(y), value, 1.0);
}