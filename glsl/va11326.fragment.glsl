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

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) / 4.0;
	vec3 hsv_color = vec3(sin(gl_FragCoord.x / resolution.x)+cos(gl_FragCoord.y / resolution.y)*sin(0.87) + 0.5, 1.0,0.25+0.75);
	hsv_color.x += abs(.5 - sin(time));
	gl_FragColor = vec4( hsv2rgb(hsv_color),1.0);
}