// code by guanqun.lu@gmail.com

#ifdef GL_ES
precision lowp float;
#endif

uniform vec2 mouse;
uniform vec2 resolution;
uniform float time;

float rand(vec2 co){  return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453); }

void main()
{
	vec3 color;
	float radius = 40.0 + sin(time * 10.);

	vec2 pixel = gl_FragCoord.xy;
	vec2 point = floor(mouse * resolution);	

	radius += 4. * rand(pixel) * rand(pixel);
	
	float x = radius - distance(pixel.xy, point.xy) ;
	if (x < 0.0) {
		discard;
	} else {
		color = vec3(0.4 , sin(x * rand(point)) , .0);
	}

	gl_FragColor = vec4(color, 1.0);
}