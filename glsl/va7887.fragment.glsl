#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform vec2 surfaceSize;
varying vec2 surfacePosition;

// B
// Drag rmb to increase / decrease size

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	vec4 color = vec4(0.);
	color.x = ((sin(time * 2.)*1.+2.) * .04) / length(position - .5);
	color.y = color.x * color.x;
	color.z = color.y * color.y;

	vec4 color2 = vec4(0.);
	color2.x = (.04) / length(position - mouse) / surfaceSize.x;
	color2.y = color2.x * color2.x;
	color2.z = color2.y * color2.y;
	
	color += color2;
	
	gl_FragColor = color;

}