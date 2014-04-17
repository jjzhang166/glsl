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

    float step1 = resolution.y * 0.25;
    float step2 = resolution.y * 0.50;
    float step3 = resolution.y * 0.75;

    if (y < step1) {
        color = white;
    } else if (y < step2) {
        float x = smoothstep(step1, step2, y);
        color = mix(white, red, x);
    } else if (y < step3) {
        float x = smoothstep(step2, step3, y);
        color = mix(red, blue, x);
    } else {
        float x = smoothstep(step3, resolution.y, y);
        color = mix(blue, green, x);
    }

    gl_FragColor = color;
	gl_FragColor = vec4(gl_FragCoord.y,gl_FragCoord.y,gl_FragCoord.y,1.0);	
}
