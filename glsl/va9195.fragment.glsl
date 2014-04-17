#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D source;
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform float lines;
uniform float width;
uniform float intensity;


void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	vec4 pixel = texture2D(source, position);
	
	float darken = 2.0 * abs( fract(position.y * lines) - 0.5);
	darken = clamp(darken - width + 0.5, 0.0, 1.0);
	darken = 1.0 - ((1.0 - darken) * intensity);
	gl_FragColor = vec4(pixel.rgb * darken, 1.0);

}