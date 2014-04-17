#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mousel
	;
uniform vec2 resolution;

uniform sampler2D tex;

/*
Float packing from
http://uncommoncode.wordpress.com/2012/11/07/float-packing-in-shaders-encoding-multiple-components-in-one-float/
*/

// c_precision of 128 fits within 7 base-10 digits
const float c_precision = 128.0;
const float c_precisionp1 = c_precision + 1.0;

/*
\param color normalized RGB value
\returns 3-component encoded float
*/
float color2float(vec3 color) {
	//color = clamp(color, 0.0, 1.0);
	return floor(color.r * c_precision + 0.5) 
		+ floor(color.b * c_precision + 0.5) * c_precisionp1
		+ floor(color.g * c_precision + 0.5) * c_precisionp1 * c_precisionp1;
}

/*
\param value 3-component encoded float
\returns normalized RGB value
*/
vec3 float2color(float value) {
	vec3 color;
	color.r = mod(value, c_precisionp1) / c_precision;
	color.b = mod(floor(value / c_precisionp1), c_precisionp1) / c_precision;
	color.g = floor(value / (c_precisionp1 * c_precisionp1)) / c_precision;
	return color;
}

//#define PLOT_ERROR
#define PLOT_NORMALIZED_ERROR

void main(void)
{
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	
	vec3 inColor = vec3(uv, 0.5);
	
	// pack a color in a float
	float packedValue = color2float(inColor);
	// unpack the color!
	vec3 outColor = float2color(packedValue);
	
	// color should be very similar
#if defined(PLOT_ERROR)
	float similarity = dot(normalize(outColor), normalize(inColor));
	float angleError = 1.0 - similarity;
	vec3 y = vec3(0.2, 0.7, 0.1);
	float luminosityError = dot(outColor, y) - dot(inColor, y);
	#if defined(PLOT_NORMALIZED_ERROR)
		gl_FragColor = vec4(normalize(vec3(angleError, -luminosityError, luminosityError)), 1.0);
	#else
		gl_FragColor = vec4(vec3(angleError, -luminosityError, luminosityError), 1.0);
	#endif
#else
	float t = sin(time * 2.0) * 0.5 + 0.5;
	gl_FragColor = vec4(mix(outColor, inColor, t), 1.0);
#endif
}
