// by @301z
// based on http://devmaster.net/forums/topic/4648-fast-and-accurate-sinecosine/

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

const float PI = 3.14159;

float sinApprox(float x) {
    float Pi = PI*fract(time*0.001);
    x = Pi + (2.0 * Pi) * float(int((x / (2.0 * Pi)))) - x;
    return (4.0 / Pi) * x - (4.0 / Pi / Pi) * x * (x < 0.0 ? -x : x);
}

void main() {
    float x = gl_FragCoord.x / resolution.x, t = 4.0 * PI;
    float s = (sinApprox(x * t) * 0.25 + 0.5) * resolution.y;
  
    gl_FragColor = vec4(vec3(abs(s - gl_FragCoord.y))-0.5, 1.0);
    
}
