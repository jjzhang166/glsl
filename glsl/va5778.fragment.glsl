#ifdef GL_ES
precision mediump float;
#endif

// Posted by Trisomie21 : 2D noise experiment (pan/zoom in 1:1 res)

uniform float time;
uniform vec2 resolution;
varying vec2 surfacePosition;

float textureRND2D(vec2 uv){
	uv = floor(fract(uv)*1e3);
	return fract(sin(uv.x/1e3+uv.y)*1e5);
}

float hash(vec2 n)
{
    return fract(sin(dot(n, vec2(14.9898,78.233))) * 43758.5453);
}

void main( void ) {
	if(gl_FragCoord.x < resolution.x*.5) {
		gl_FragColor = vec4( vec3(step(hash(surfacePosition), .5)), 1.0);
	} else {
		gl_FragColor = vec4( vec3(step(textureRND2D(surfacePosition), .5)), 1.0);
	}
}