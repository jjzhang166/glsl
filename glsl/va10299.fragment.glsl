#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform sampler2D texture;
uniform float PosY;

uniform float Yoffset;

void main()
{
    vec2 position = ( gl_FragCoord.xy / resolution.xy );
	position = vec2(position.x, position.y - (Yoffset / resolution.y));
    vec4 color = texture2D(texture, position);
	
	gl_FragColor = color;
}