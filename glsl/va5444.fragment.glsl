
// Circle Outline (better technic?) ~GijsB

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main(void) {
	vec2 PixelPos = gl_FragCoord.xy;
	vec3 Color = vec3(1.0,1.0,1.0);
	
	vec2 CirclePos = mouse*resolution;
	float CircleBorderWidth = 10.0;
	float CircleWidth = 100.0;
	
	float DistanceToCircle = distance(PixelPos,CirclePos);
	float a = abs(DistanceToCircle-CircleWidth)-CircleBorderWidth*.5;
	a = 1.0-clamp(a, 0.0, 1.0);
	
	gl_FragColor = vec4(Color*a,1.0);
}