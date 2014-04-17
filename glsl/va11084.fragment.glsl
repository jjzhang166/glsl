#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
    vec2 position = ( gl_FragCoord.xy / resolution.xy );
    vec4 color = texture2D(backbuffer, position);
	color.x *= 1.0;
	gl_FragColor = color;
}
