// Playing around with Lissajous curves.
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

const int num = 1000;

void main( void ) {
    float sum = 0.0;
	
    float size = resolution.x / 1000.0;
	
    for (int i = 0; i < num; ++i) {
        vec2 position = resolution / 2.0;
	float t = (float(i) + time) / 2.0;
	float c = float(i) * 4.0;
        position.x += sin(10.0 * t + c) * resolution.x * 0.2;
        position.y += tan(t) * resolution.y * 5.0;

        sum += size / length(gl_FragCoord.xy - position);
    }
	
    gl_FragColor = vec4(sum * 0.1 , sum * .7 * cos(time / 100.0), sum * sin(time), 0.5);
}