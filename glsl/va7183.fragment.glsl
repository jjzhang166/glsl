#ifdef GL_ES
precision mediump float;
#endif

//mkohler

uniform float time;
uniform vec2 resolution;

void main( void ) {

    vec2 position = (gl_FragCoord.xy / resolution.xy) - 0.5;

    const float T = 16.0;
    float t = mod(time, T);
    t = smoothstep(0.0, T/2.0, t) - smoothstep(T/2.0, T, t);
    t = 0.5 * sin(600.0 * position.y * t) + 0.5;
	
	float u = mod(time, T);
    u = smoothstep(0.0, T/2.0, u) - smoothstep(T/2.0, T, u);
    u = 0.5 * sin(600.0 * position.x * u) + 0.5;
	
    gl_FragColor = vec4(t,0.0,u, 1.0);

}