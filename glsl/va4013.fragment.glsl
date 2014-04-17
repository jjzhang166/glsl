// color clock
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec4 angle2rgb(float a) {
    // convert number in range 0-1 to red@0.000, green@0.333, blue@0.667
    a = clamp(a, 0.0, 1.0);
    if(a<1.0/3.0)
        return mix(vec4(1.0,0.0,0.0, 1.0), vec4(0.0,1.0,0.0, 1.0), a*3.0);
    else if(a<2.0/3.0)
        return mix(vec4(0.0,1.0,0.0, 1.0), vec4(0.0,0.0,1.0, 1.0), a*3.0-1.0);
    else
        return mix(vec4(0.0,0.0,1.0, 1.0), vec4(1.0,0.0,0.0, 1.0), a*3.0-2.0);
}


void main(void) {
    vec2 p = ( gl_FragCoord.xy / resolution.y ); // normalize y-axis
    p -= vec2((resolution.x/resolution.y)/2.0, 0.5); // center origin

    float r = length(p); // radius

    if(r<0.15)
        gl_FragColor = angle2rgb(mod(time/60.0, 1.0)); // 60 s
    else if(r<0.3)
        gl_FragColor = angle2rgb(mod(time/3600.0, 1.0)); // 60 min
    else if(r<0.45)
        gl_FragColor = angle2rgb(mod(time/43200.0, 1.0)); // 12 h
    else
        gl_FragColor = angle2rgb(mod(atan(p.x, p.y)/6.28318, 1.0));
}
