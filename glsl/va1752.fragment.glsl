#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
p.y *= resolution.y/resolution.x;
    vec2 m = -1.0 + 2.0 * mouse.xy / resolution.xy;
m *=10.0;
float t = time*3.0;
    float a = atan(p.y,p.x );
    float r = length(p);
float sd = sign(r-0.5);
float c = sin(r*70.*sin(t) + sin(a*20.0)*0.5 ) >0. ? 0. : 1.0;

    gl_FragColor = vec4(c,c,c,1.0);


}