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

	float x = radius * radius - (pixel.x - point.x)*(pixel.x-point.x) - (pixel.y - point.y)*(pixel.y-point.y);
	if (x < 0.0) {
		color = vec3(1.0, 0.5, 0.5);
	} else {
		color = vec3(0.0, 1.0, 0.0);
	}

	gl_FragColor = vec4( color, 1.0);
}