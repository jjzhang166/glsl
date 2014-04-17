#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.1415926535

void main(void)
{
 float spin;
 
 vec2 position = 100.0 * ((gl_FragCoord.xy) / resolution.x);
 
 float r = length(position);
 float a = atan(position.y, position.x);
 float d = r - a;
 float n = PI * float(int(d / PI));
 float k = a + d ;
 
 spin = time*0.315;
 
 float rand = sin(0.0002 * floor((0.002) * n * k + (spin)));
 
 gl_FragColor.rgba = vec4(fract((o) * rand * n * vec3(0.2, 0.1, 0.1)), 1.0);
}
#define PI 3.1415926535