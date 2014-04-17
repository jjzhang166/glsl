#ifdef GL_ES
precision highp float;
#endif

// Ian Thomas
// Toxic Bakery http://toxicbakery.com/

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float lights[6];
vec4 color = vec4(1.0, 1.0, 1.0, 1.0);

void do_color(float x, float y, inout vec4 color) {
	if (x * 10.0 - gl_FragCoord.x < 0.0 && (x + 1.0) * 10.0 - gl_FragCoord.x > 0.0) {
		if (y * 10.0 - gl_FragCoord.y < 0.0 && (y + 1.0) * 10.0 - gl_FragCoord.y > 0.0) {
			color.rgb = vec3(1.0, 0.0, 0.0);
		}
	}
}

void main( void ) {	
	for (int i = 0;i < 6;i+=2) {
		lights[i] = float(i);
		lights[i + 1] = float(i);
		do_color(lights[i], lights[i+1], color);
	}
	
	vec2 light = floor(mouse * resolution / 10.0);
	
	vec2 pos = vec2(floor(mod(gl_FragCoord.x, 10.0)), floor(mod(gl_FragCoord.y, 10.0)));
	
	do_color(light.x, light.y, color);
	
	color.rgb *= pos.x * pos.y;
	
	gl_FragColor = color;

}