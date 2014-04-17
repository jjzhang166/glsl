#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec2 pixel;

float noise2(vec2 v) {
	return fract(sin(dot(v.xy, vec2(12.9898,78.233))) * 43758.5453)/2.0;
	v = sin(v*5000.0)*atan(v*5000.0);
	return clamp(tan(v.x*v.y*5000.0+cos(v.x*5000.0))/sin(v.y*v.x)*tan(dot(v, v)), 0.0, 1.0)/2.0;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy )+time/5000000.0;
	pixel = 1.0 / resolution.xy;

	float color = noise2(position) +
		noise2(vec2(position.x+pixel.x, position.y)) + 
		noise2(vec2(position.x-pixel.x, position.y)) + 
		noise2(vec2(position.x, position.y+pixel.y)) + 
		noise2(vec2(position.x, position.y-pixel.y));
	gl_FragColor = vec4( 0.20 + color*0.37, 0.02 + color*0.05, 0.02 + color*0.05, 1.0 );

}