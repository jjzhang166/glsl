#ifdef GL_ES
precision highp float;
#endif
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
    vec2 position = ( gl_FragCoord.xy / resolution.xy );
    vec4 color = texture2D(backbuffer, position);
    	gl_FragColor.r = color.r * 0.8;
	gl_FragColor.g = color.g * 0.8;
	gl_FragColor.b = color.b * 0.8;
	gl_FragColor.a = color.a;
}
