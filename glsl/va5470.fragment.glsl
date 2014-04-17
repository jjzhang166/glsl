#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main(void) {
	vec2 PixelPos = gl_FragCoord.xy/resolution;
	vec3 Color = vec3(PixelPos.y,1.0-PixelPos.x,PixelPos.x-PixelPos.y);
	float dist = sqrt(pow(PixelPos.x-mouse.x,2.0)+pow(PixelPos.y-mouse.y,2.0));
	Color = vec3(Color.x-dist,Color.y-dist,Color.z-dist);
	gl_FragColor = vec4(Color,1.0);
}