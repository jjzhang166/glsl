#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main( void ) {
	vec2 center = resolution / 2.0;
	
	float xDistance = abs(center.x - gl_FragCoord.x);
	
	float normalizedXDistance = xDistance / resolution.x;
	
	float hue = sin(normalizedXDistance / 2.0) - (time / 1.0) + sin(time) * 0.5;
	float saturation = time / 400.0;
	float value = 1.0 - xDistance / resolution.x;
	
	gl_FragColor = vec4(hsv2rgb(vec3(hue, saturation, value * value)), 1);
}
