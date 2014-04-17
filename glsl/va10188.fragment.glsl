#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main() {
    vec4 color;
    float y = gl_FragCoord.y;
    float x = gl_FragCoord.x;
    
    vec4 white = vec4(1);
    vec4 red = vec4(0.8, 0.3, 0.3, 1);
    vec4 blue = vec4(0.3, 0.6, 1, 1);
    vec4 green = vec4(0.3, 1, 0.3, 1);

    float step1 = resolution.y * 0.00*(time/1000.0);
    float step2 = resolution.y * 0.50*(time/1000.0);
    float step3 = resolution.y * 0.75*(time/1000.0);
    color = mix(white, red, smoothstep(step1, step2, y - 0.3*x));
    color = mix(color, blue, smoothstep(step2, step3, y - 0.3*x));
    color = mix(color, green, smoothstep(step3, resolution.y, y - 0.3*x));
	
    gl_FragColor = vec4(1,time/500.0,1,1);
}
