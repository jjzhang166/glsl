#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec4 mouse;
uniform sampler2D tex0;
uniform sampler2D tex1;


//quasicrystals
const float pi = 3.1415926;

void main(void)
{
    vec2 p = -1.0 + 1.0 * gl_FragCoord.xy / resolution.xy;
p.y *= resolution.y/resolution.x;
p *= 300.0;
const float tot = pi*6.10;
const float n = 6.4;
const float df = tot/n;
    float c = 3.0;
float t = time*0.70;

for (float phi =0.0; phi < tot; phi+=df){
c+=cos(cos(phi) * p.x + sin(phi)*p.y +t);
}
//c/=n;
	//c = c>0.5?0.:1.;
    gl_FragColor = vec4(c,c,c,1.0);
}
