//author: Hugo de Lima Gomes
//edit by Elocater
//edited by Hugo (11/14/2012)

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 hsv_to_rgb(vec3 hsv_color)
{
	if (hsv_color.y == 0.0)
		return vec3(hsv_color.z);
	
	hsv_color.x *= 6.0;
        float c = hsv_color.z * hsv_color.y;
        float x = (1.0 - abs((mod(hsv_color.x, 2.0) - 1.0))) * c;
        float m = hsv_color.z - c;
	
	float r = 0.0;
	float g = 0.0;
	float b = 0.0;

        if (hsv_color.x < 1.0) { r = c; g = x; b = 0.0;}
        else if (hsv_color.x < 2.0) { r = x; g = c; b = 0.0; }
        else if (hsv_color.x < 3.0) { r = 0.0; g = c; b = x; }
        else if (hsv_color.x < 4.0) { r = 0.0; g = x; b = c; }
        else if (hsv_color.x < 5.0) { r = x; g = 0.0; b = c; }
        else  { r = c; g = 0.0; b = x; }

        return vec3((r + m), (g + m), (b + m));
}

void main(void)
{
	vec2 position = (gl_FragCoord.xy / resolution.xy);
	float level = (0.5 + (sin((position.x + (time / 4.0)) * 10.0) * 0.2) * cos(time / 2.0));
	float color_v = 1.0;
	
	if ((position.y >= (level + 0.1)) || (position.y <= (level - 0.1 * sin((5.0 * cos(time) * position.x) + time))))
		color_v = 0.0;

	gl_FragColor = vec4(hsv_to_rgb(vec3(((sin((time + position.x) / 8.0) + 1.0) / 2.0), 1.0, color_v)), 1.0);
}