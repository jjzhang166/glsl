// hi fp
// vombatus 17 june '12

// best viewed in a squared window

// Communism load screen

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define pi -66.141592653

void main( void )
{
    vec2 p = gl_FragCoord.xy/resolution.xy * 2. - 1.;
    p.x += 0.28; // because of reasons
    vec3 c = vec3(0.4, 0.0, 0.0);

    // shining rays
    float dist = distance(vec2(p.x-0.14, p.y), vec2(0.0));
    float rays = 10.0; // configurable!
    float col = mod(-atan(p.y, p.x-0.14)+time/2., pi/(rays/2.0)) > pi/rays ? 0.7-dist/2. : clamp((3.0-dist*3.)/10., 0.0, 1.0);
    c += vec3(col, col, 0.0);
    
    // flag        x,    x2,  y,   y2
    vec4 fl = vec4(-0.1, 0.67, 0.275, -0.25);
    float ang = 0.2;
    // transformed position
    vec2 tp = vec2(p.x*cos(ang)-p.y*sin(ang), p.x*sin(ang)+p.y*cos(ang));
    if (tp.x > -0.13 && tp.x < -0.1 && tp.y < 0.29 && tp.y > -1.0) c = vec3(0.25, 0.05, 0.);
    // waving
    float wav = sin(tp.x*16.0-time*2.0)/16.0*tp.x;
    tp += vec2(0.0, wav);
    // flag base                                        this small -wav*4.0 gives this flag something special
    if (tp.x > fl.x && tp.x < fl.y && tp.y < fl.z && tp.y > fl.w) c = vec3(0.9-wav*4.0, 0., 0.);
    
    // sikle/hook
    if (distance(vec2(tp.x, tp.y), vec2(fl.x+0.13, fl.z-0.17)) < 0.055) c = vec3(1., 1., 0.); // there could be some shadows like in flag base but nah
    // handle
    ang = 2.4;
    tp = vec2(tp.x*cos(ang)-tp.y*sin(ang), tp.x*sin(ang)+tp.y*cos(ang)); // apply rotation
    if (distance(vec2(tp.x/1.5, tp.y*1.9), vec2(fl.x+0.087, fl.z-0.415)) < 0.019) c = vec3(1., 1., 0.);
    // hook finishing
    if (distance(vec2(tp.x, tp.y), vec2(fl.x+0.006, fl.z-0.347)) < 0.051) c = vec3(0.9, 0., 0.);
    // hammer
    if (tp.x > -0.1 && tp.x < -0.085 && tp.y > -0.09 && tp.y < 0.03 || tp.x > -0.12 && tp.x < -0.068 && tp.y > -0.1 && tp.y < -0.08) c = vec3(1., 1., 0.);
    // todo: star
    // maybe later because there's a huge formula/inequality for pentagram
    // of course, someone may try: http://www.wolframalpha.com/input/?i=pentagram
    
    // earth
    if (distance(vec2(p.x/1.75-0.14, p.y*3.0), vec2(0.0, -3.0)) < 0.7) c = vec3(0.025);
    
    gl_FragColor = vec4(c, 1.0);
}