#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

       vec2 position = ( gl_FragCoord.xy / resolution.xy );// + mouse / 4.0;

       float color = mod((position.x + position.y), 0.05) * 5.0 + mod((position.x - position.y), 0.05) * 5.0;
       gl_FragColor = vec4(color + 0.1, color / 2.0, color + 0.3, 1);

}