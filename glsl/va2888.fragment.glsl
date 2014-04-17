// just a quickie
// idea from Lou's pseudo 3d page http://www.gorenfeld.net/lou/pseudo/
// yes, I remember there is some old one somewhere in the page 30-40 but I wanted to make one from scratch

precision mediump float;
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

void main(void)
{
    vec2 p = gl_FragCoord.xy / resolution.xy * 2.0 - 1.0;

    vec2 uv = vec2(p.x/abs(p.y), 1.0/p.y);
    uv.y += time;

    vec3 col = vec3(0, 0.6, 1.0);
    float rx = tan(gl_FragCoord.x/100.0 + time);
    float rw = 1.0;
    if (p.y < 1.0)
    {
        mod(uv.y, 2.) >= 1. ? col = vec3(0., 1., 0.) : col = vec3(0., 0.9, 0.);
	    if (uv.x >= rx-rw-0.1 && uv.x <= rx+rw+0.1) { mod(uv.y, 0.4) >= 0.2 ? col = vec3(1.) : col = vec3(0.9, 0., 0.); }
        if (uv.x >= rx-rw && uv.x <= rx+rw) col = vec3(0.3);
        if (uv.x >= rx-0.025 && uv.x <= rx+0.025 && mod(uv.y, 1.) >= 0.5) col = vec3(1.0, 0.8, 0.);
    }
    gl_FragColor = vec4(col, 1.0);
}