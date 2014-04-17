
// Circle Outline (better technic?) ~GijsB

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main(void) {
	vec2 PixelPos = gl_FragCoord.xy;
	vec3 Color = vec3(0.0,0.0,0.0);
	
	vec2 CirclePos = vec2(mouse.x*resolution.x,mouse.y*resolution.y);
	float CircleBorderWidth = 10.0;
	float CircleWidth = 100.0;
	
	float DistanceToCircle = distance(PixelPos,CirclePos);
	if (DistanceToCircle > CircleWidth-CircleBorderWidth/2.0) {
		if (DistanceToCircle < CircleWidth+CircleBorderWidth/2.0) {
			 Color = vec3(1,1,1);
		}
	}
	gl_FragColor = vec4(Color,1.0);
}