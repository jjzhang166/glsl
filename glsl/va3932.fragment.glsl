#ifdef GL_ES
precision highp float;
#endif

//The heart from shadertoy with 2 bytes added.
//Can you find them?

uniform float time;
uniform vec2 resolution;
uniform vec4 mouse;

void main(void)
{
    vec2 p = (2.0*gl_FragCoord.xy-resolution)/resolution.y;

p.x *= 0.25;
	p.y += 0.5;
    // animate
    float tt = mod(time,4.0);
    float ss = pow(tt,.05);
    ss -= ss*0.4*sin(tt*8.0)*exp(-tt);
    p *= vec2(4.0,3.9) + ss*vec2(0.125,-2.5);

    
    float a = atan(p.x,p.y);
    float r = length(p);

    // shape
    float h = abs(a*r*r);
    float d = (19.0*h - 22.*h*h + 6.0*h)/(6.0-6.0*h*r);

    // color
    float f = step(r,d) * pow(1.0-r/d,0.25);

    gl_FragColor = vec4(f*0.9*(1.5-r),f*0.36,f*0.15,1.0);
}