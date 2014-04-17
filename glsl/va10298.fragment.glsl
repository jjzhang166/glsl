#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform sampler2D backbuffer;

void main()
{
    vec2 position = ( gl_FragCoord.xy / resolution.xy );
    vec4 color = texture2D(backbuffer, position);
	
	gl_FragColor = color;
}
