#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform sampler2D tex;

// c_precision of 128 fits within 7 base-10 digits
const float c_precision = 6.0;
const float c_precisionp1 = c_precision + 1.0;

/*
\param color normalized RGB value
\returns 3-component encoded float
*/
float color2float(vec3 color) {
    return floor(color.r * (c_precision) + 0.0) 
		+ floor(color.b * (c_precision) + 0.0) * c_precisionp1
		+ floor(color.g * (c_precision - 1.0) + 0.0) * c_precisionp1 * c_precisionp1;
}

/*
\param value 3-component encoded float
\returns normalized RGB value
*/
vec3 float2color(float value) {
    vec3 color;
    color.r = mod(value, c_precisionp1) / (c_precisionp1 - 1.0);
    color.b = mod(floor(value / c_precisionp1), c_precisionp1) / (c_precisionp1 - 1.0);
    color.g = value / (c_precisionp1 * c_precisionp1 * (c_precisionp1 - 1.0));
    return color;
}

void main(void)
{
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec3 color = vec3(1.0, uv);
	float cc = color2float(color.rgb);
	vec3 outcolor = float2color(cc);
	gl_FragColor = vec4(outcolor.rgb, 1.0);
}
