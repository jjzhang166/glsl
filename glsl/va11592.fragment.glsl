#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

int starCount = 20;

vec4 hsv2rgba(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return vec4(c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y), 1);
}

void main( void ) {
	// Space
	vec2 center = resolution / 2.0;
	
	float xDistance = abs(center.x - gl_FragCoord.x);
	
	float normalizedXDistance = xDistance / resolution.x;
	
	float hue = sin(normalizedXDistance / 3.0) - (time / 10.0) + sin(time) * 0.2;
	float saturation = time / 5000.0;
	float value = 1.0 - xDistance / resolution.x;
	
	vec4 spaceColor = hsv2rgba(vec3(hue, saturation, value * value));
	
	// Tunnel color
	vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
  
	float a = -0.05;
	float r = length(p);
 
	float b = 2.0 * cos (-time * 12.0 - 3.00  / r);
	b = pow(b, r);
	//b *= smoothstep(0.05, 0.6, 0.3*b*r);
 
	vec4 tunnelColor = hsv2rgba(vec3(hue, b, value));
	
	gl_FragColor = spaceColor + tunnelColor;
}
