#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main() {
    vec4 color;
    float y = gl_FragCoord.y;
    
    vec4 white = vec4(1);
    vec4 red = vec4(1, 0, 0, 1);
    vec4 blue = vec4(0, 0, 1, 1);
    vec4 green = vec4(0, 1, 0, 1);

    float step1 = resolution.y * 0.10;
    float step2 = resolution.y * 0.50;
    float step3 = resolution.y * 0.65;

	color = mix(white, red, smoothstep(step1, step2, y));
	color = mix(color, blue, smoothstep(step2, step3, y));
	color = mix(color, green, smoothstep(step3, resolution.y, y));
	
    gl_FragColor = color;
}
