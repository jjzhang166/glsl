#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec4 mouse;
varying vec2 surfacePosition;
uniform vec2 surfaceSize;

const int lim = 7;

void main(void)
{
	vec2 coordIter = surfacePosition + 0.5;
	vec2 sector;

	for(int i=0; i<lim; i++){
		sector = floor(coordIter * 3.0);
		if (sector == 1.0){
			gl_FragColor = vec4(0);
			return;
		}
		else {
			coordIter = coordIter * 3.0 - sector;
		}
	}
	vec2 col = fract(surfacePosition);
	gl_FragColor = vec4(col.x, 0.5, col.y, 1.0);
}