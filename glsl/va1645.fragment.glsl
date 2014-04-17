#ifdef GL_ES
precision highp float;
#endif

uniform vec2 mouse;
uniform vec2 resolution;
uniform float time;

vec3 h(float x, float y){
    float s = mod(time,1.0);
    s = 1.0 + (1.0-exp(-5.0*s)*sin(9.0*s));
    x *= s;
    y *= s;

    float h = abs(atan(x,y)/3.14) * mouse.x;
    float d = (13.0*h - 22.0*h*h + 10.0*h*h*h)/(6.0-5.0*h) * mouse.y;
    return mix(vec3(1.0,0,0),vec3(1.0),smoothstep(d-0.05,d,sqrt(x*x+y*y)));
}


void main(){
    vec2 p = vec2(-1.0+2.0*gl_FragCoord.xy/resolution.xy);
    gl_FragColor = vec4(h(p.x,p.y),1.0);
}
