#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

			 
void main( void ) {

	vec2 screen_center;
	vec2 pos0;

	
	vec3 color;
	
	float radius1;
	float radius2;
	float dist0;

	radius1 = min(resolution.x, resolution.y)*0.25;
	radius2 = radius1 * 0.25;

	screen_center = resolution * 0.5;
	
	
	pos0 = vec2 (
		screen_center.x + sin(time) * radius1,
		screen_center.y + cos(time) * radius1
	);

	dist0 = length(pos0 - gl_FragCoord.xy);
	
	
	color = texture2D(backbuffer, 0.97*gl_FragCoord.xy/resolution).rgb;
	color = vec3(color.r*1.03, color.g*1.01, color.b*1.02)*0.95;
	
	if (dist0 < radius2) {
		gl_FragColor = vec4(0.5,0.75,0.25,1.0);
	} else {
		gl_FragColor = vec4(color, 1.0);
	}
}