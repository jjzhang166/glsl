// code by guanqun.lu@gmail.com

#ifdef GL_ES
precision lowp float;
#endif

uniform vec2 mouse;
uniform vec2 resolution;

void main()
{
	vec3 color;
	float radius = 20.0;

	vec2 pixel = gl_FragCoord.xy;
	vec2 point = floor(mouse * resolution);	

	float x = radius - distance(pixel.xy, point.xy);
	if (x < 0.0) {
		discard;
	} else {
		color = vec3(0.0, 1.0, 0.0);
	}

	gl_FragColor = vec4(color, 1.0);
}