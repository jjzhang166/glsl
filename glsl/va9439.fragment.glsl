// fuck that shit.

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void) 
{

	vec2 position = gl_FragCoord.xy / resolution.xy;
	float col = 0.0;
	if (mouse.x > position.x - 0.0) col = 1.0; //I hate grey MODERFUKER
	gl_FragColor = vec4(vec3(col), 1.0);

}
