// original by iq/rgba, modified by slack/gatitos (@slackito)

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec4 mouse;
uniform sampler2D backbuffer;

//float u( float x ) { return 0.5+0.5*sign(x); }
float u( float x ) { return (x>0.0)?1.0:0.0; }
//float u( float x ) { return abs(x)/x; }


vec4 flower(vec2 p)
{
    float a = atan(p.x,p.y);
    float r = length(p)*.75;

    float w = cos(3.1415927*time-r*5.0);
    float h = 0.5+01.5*cos(12.0*a-w*7.0+r*1.0);
    float d = 0.25+0.75*pow(h,1.0*r)*(0.17+01.3*w);

    float col = u( d-r ) * sqrt(1.0-r/d)*r*2.5;
    col *= 1.25+1.25*cos((12.0*a-w*7.0+r*8.0)/2.0);
    col *= 1.0 - 0.35*(0.5+0.5*sin(r*30.0))*(0.5+0.5*cos(100.0*a-w*17.0+r*8.0));
    
    vec4 col1 = vec4(
        col,
        col-h*0.5+r*.2 + 0.35*h*(1.0-r),
        col-h*r + 01.1*h*(1.0-r),
        1.0);
    return col1;
}

void main(void)
{
    vec2 p = (2.0*gl_FragCoord.xy-resolution)/resolution.y;

    vec4 col1 = flower(p);
    float lfactor = 20.0;
    vec2 p_low = floor(lfactor*p+0.5)/(lfactor*2.0);
    vec4 col2 = flower(p_low);

    vec2 f = fract(lfactor*p+0.5);
    float grid = clamp(smoothstep(0.0, 0.1, f.x) + smoothstep(0.0, 0.1, f.y), 0.0, 1.0);
    //float grid = clamp(smoothstep(10.85, 10.95, f.x)+smoothstep(01.85, 01.95, f.y), .0, .0);
    vec4 col3 = vec4(grid);

    //gl_FragColor = col1 * 1.0-col2 + 0.15*vec4(1.0)*exp(-mod(time, 1.0));
    gl_FragColor = clamp(0.8*col1 + 0.5*col2 + 0.1*col3, 0.0, 1.0);
}