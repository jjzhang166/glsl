/*
 * Backbuffer + Blur + Some nice function + Mouse interaction = Art?
 * By ShyRed ( https://github.com/ShyRed )
 */

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;
	vec4 color;

	// Calculate squared distance from mouse cursor to current position
	float distMouseSqrd = (position.x - mouse.x) * (position.x - mouse.x) + (position.y - mouse.y) * (position.y - mouse.y);

	// Mess with the position by adding values. By changing / modifying
	// this part, new effects can be created.
	position.x += cos(time + position.y * 60.0) * 0.01;
	position.y += sin(time + position.x * 60.0) * 0.01;
	
	// Color is the average color of 4 surrounding positions (blur)
	color = (texture2D(backbuffer, position + vec2(0.0, 0.01))
		+ texture2D(backbuffer, position + vec2(0.0, -0.01))
		+ texture2D(backbuffer, position + vec2(0.01, 0.0))
		+ texture2D(backbuffer, position + vec2(-0.01, 0.0))) / 4.0;
	
	// Make colors go darker and add variantion by adding values.
	color.x *= 0.997 + sin(time * 2.0) * 0.01;
	color.y *= 0.996 + cos(time * 2.0) * 0.01;
	color.z *= 0.995 + cos(time * 4.0) * 0.01;
	
	// Draw "light source"
	color += vec4(0.00002 / (0.00002 + distMouseSqrd));

	gl_FragColor = color;

}