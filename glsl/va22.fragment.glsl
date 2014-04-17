//by @acaudwell

#ifdef GL_ES
precision highp float;
#endif
uniform float time;
uniform vec2 resolution;

// T H E . A L P H A  . B L E N D E R S
// SO ADDICTIVE ARGHHHH

void main( void ) {
    vec2 p1 = (gl_FragCoord.xy / resolution) - 0.5 + normalize(vec2( sin(abs(fract(time*0.3))*6.284) , -sin(abs(fract(time*0.3))*6.284)))*0.25;
    vec2 p2 = (gl_FragCoord.xy / resolution) - 0.5 + normalize(vec2( sin(abs(fract(-time*0.5))*6.284) , -sin(abs(fract(-time*0.1))*6.284)))*0.25;

    vec2 q = p2 + mod(fract(p1)*p1*1000.0, 5.0);
    
    float lines = abs(length(p1/q) * sin(time*0.1));

    gl_FragColor = vec4(vec3(0.1,0.1,0.1)*lines,1.0);
}