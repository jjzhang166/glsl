#ifdef GL_ES
precision mediump float;
#endif

// precision medump float;
uniform vec4 vColor;
void main() {
    gl_FragColor = vColor;
}