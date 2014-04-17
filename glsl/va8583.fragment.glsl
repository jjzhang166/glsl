#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 mouse;
uniform float time;
uniform vec2 resolution;

float hue_to_rgb(float f1, float f2, float hue) {
	if (hue < 0.0)
		hue += 1.0;
	else if (hue > 1.0)
		hue -= 1.0;
	float res;
	if ((6.0 * hue) < 1.0)
		res = f1 + (f2 - f1) * 6.0 * hue;
	else if ((2.0 * hue) < 1.0)
		res = f2;
	else if ((3.0 * hue) < 2.0)
		res = f1 + (f2 - f1) * ((2.0 / 3.0) - hue) * 6.0;
	else
		res = f1;
	return res;
}

vec3 hsl_to_rgb(vec3 hsl) {
	vec3 rgb;

	if (hsl.y == 0.0)
		rgb = vec3(hsl.z); // Luminance
	else {
		float f2;

		if (hsl.z < 0.5)
			f2 = hsl.z * (1.0 + hsl.y);
		else
			f2 = (hsl.z + hsl.y) - (hsl.y * hsl.z);

		float f1 = 2.0 * hsl.z - f2;

		rgb.r = hue_to_rgb(f1, f2, hsl.x + (1.0/3.0));
		rgb.g = hue_to_rgb(f1, f2, hsl.x);
		rgb.b = hue_to_rgb(f1, f2, hsl.x - (1.0/3.0));
}

return rgb;
}
void main(void) {	
	vec2 position = ( gl_FragCoord.xy - resolution.xy * 0.5 ) / length(resolution.xy) * 400.0;
	float color;
	position.xy += mouse.xy / resolution.xy;
	
	gl_FragColor = vec4(hsl_to_rgb(vec3(mouse.x, mouse.y, 0.5)), 1.);
}