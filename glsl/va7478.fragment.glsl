#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {    
    float x = gl_FragCoord.x/resolution.x - 0.5;
    float y = gl_FragCoord.y/resolution.y - 0.5;
    float m = 1.0*exp(-0.5*(pow(x,2.0) + pow(y,2.0))/pow(0.1,2.0));
    gl_FragColor.rgb = vec3( (1.0 + m*sin(100.0*x - 10.0*time))/2.0 );
}