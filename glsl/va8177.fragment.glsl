#ifdef GL_ES
precision highp float;
#endif

// Ian Thomas
// Toxic Bakery http://toxicbakery.com/

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	//vec2 light = vec2(4.0, 1.0);
	vec2 light = floor(mouse * resolution / 10.0);
	
	vec2 pos = vec2(floor(mod(gl_FragCoord.x, 10.0)), floor(mod(gl_FragCoord.y, 10.0)));
	vec4 color = vec4(1.0, 1.0, 1.0, 1.0);
	
	if (light.x * 10.0 - gl_FragCoord.x < 0.0 && (light.x + 1.0) * 10.0 - gl_FragCoord.x > 0.0) {
		if (light.y * 10.0 - gl_FragCoord.y < 0.0 && (light.y + 1.0) * 10.0 - gl_FragCoord.y > 0.0) {
			color.rgb = vec3(1.0, 0.0, 0.0);
		}
	}
	
	color.rgb *= pos.x * pos.y;
	
	gl_FragColor = color;

}