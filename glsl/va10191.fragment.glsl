#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

/********** WARNING: DO NOT RUN THIS SHADER IF YOU SUFFER FROM PHOTOSENSITIVE EPILEPSY **************/

void main( void ) {

	float t = fract(time*100.0+mouse.x+mouse.y);
	float c = 0.0;
	if (t >= 0.5) {
		c = 1.0;
	}
	gl_FragColor = vec4(vec3(c), 1.0 );

}