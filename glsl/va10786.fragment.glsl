#ifdef GL_ES
precision highp float;
#endif
#define PI 3.14159265

const vec3 yellow   = vec3 (0xff, 0x4d, 0);   
uniform float time;
uniform vec2 resolution;

float circle( float radius, vec2 p ) {
     return 1.0 - smoothstep (radius, radius, length(p));
}

void main( void ) {
     vec2 center = resolution.xy / 2.0;
     vec2 position = gl_FragCoord.xy;
     vec2 p = (position - center) / resolution.y;
     float wipe_angle = mod (0.15 * time * PI * 2.0 - PI / 2.0, PI * 2.0 );
     float angle =  mod (atan (p.y, p.x), 2.0 * PI);
     float radar = clamp (circle (0.4, p) - smoothstep (wipe_angle, wipe_angle + 0.02, angle) , 0.0, 1.0);
     vec4 y = vec4 (yellow, radar);
     vec4 o = vec4(y.a) * y;
     gl_FragColor = o;
}