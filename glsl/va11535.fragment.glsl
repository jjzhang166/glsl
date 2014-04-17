// fun with blobbies... fritschy/2013

#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D backbuffer;
uniform vec2 mouse;
uniform vec2 resolution;

// rotate by ~137.5°
const float rc = -0.737368;
const float rs =  0.675490;
const mat2 rot = mat2(rc, rs, -rs, rc);
const float radius = 800.0 / 100.0; //min(resolution.x, resolution.y) / 75.0;
const float sqr = radius * radius;

void main()
{
   vec2 coords = gl_FragCoord.xy / resolution - vec2(0.5);
   vec2 tcr = coords * rot * 0.996 + vec2(0.5);
   vec2 tcg = coords * rot * 0.99  + vec2(0.5);
   vec2 tcb = coords * rot * 0.97  + vec2(0.5);
   vec2 dd = mouse * resolution - gl_FragCoord.xy;
   float p = sqr / dot(dd, dd);
   vec3 c = vec3(texture2D(backbuffer, tcr).r * 0.975,
                 texture2D(backbuffer, tcg).g * 0.953,
                 texture2D(backbuffer, tcb).b * 0.964);
   gl_FragColor = vec4(c + vec3(p), 1.0);
}