#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

float f(float x, float y) {
    float a = x * x - y * y;
    float b = 2.0 * x * y;
    return sin((time * 2.) + sqrt(a * a + b * b)/6.);
}

void main( void ) {

    vec2 position = sin(time)*200.0*(-1.+2.*gl_FragCoord.yx  / resolution.yx);
    float color = 1.;
    color += f(position.x, position.y);

    gl_FragColor = vec4( vec3( color, color, color), 1.0 );

}