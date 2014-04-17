// Playing around with Lissajous curves.
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

const int num = 20;

void main( void ) {
    float sum = 0.1;
	
    float size = resolution.x / 300.0;
	
    for (int i = 0; i < num; ++i) {
        vec2 position = resolution / 2.0;
	float t = (float(i) + time) / 10.0;
	float c = float(i) * 8.0;
        position.x += tan(4.0 * t + c) * resolution.x * 0.1;
        position.y += sin(t) * resolution.y * .9;

        sum += size / length(gl_FragCoord.xy - position);
    }
	
    gl_FragColor = vec4(sum * 0.1, sum * 0.6, sum, 5);
}