#ifdef GL_ES
precision highp float;
#endif

// Spank!

uniform float time;
uniform vec2 resolution;
uniform vec4 mouse;

void main(void)
{
    vec2 p = (2.0*gl_FragCoord.xy-resolution)/resolution.y;

    // animate
    float tt = mod(time,2.0)/2.0;
    float ss = pow(tt,.2)*0.5 + 0.5;
    ss -= ss*0.2*sin(tt*6.2831*5.0)*exp(-tt*3.0);
    p *= vec2(0.5,-1.3) + ss*vec2(0.5, 0.2);

    
    float a = atan(p.x,p.y)/3.141593;
    float r = length(p);

    // shape
    float h = abs(a);
    float d = (11.0*h - 12.0*h*h + 3.0*h*h*h)/(6.0-5.0*h);

    // color
    float f = step(r,d) * pow(1.0-r/d,0.35);

    gl_FragColor = vec4(f,f*0.9,f,1.0);
}