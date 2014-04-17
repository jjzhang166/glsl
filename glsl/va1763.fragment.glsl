#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec4 mouse;
//uniform sampler2D tex0;
//uniform sampler2D tex1;


//quasicrystals
const float pi = 3.1415926;

void main(void)
{
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
    p.y *= resolution.y/resolution.x;
    p *= 300.0; //effects scale
    const float tot = pi*2.0;
    const float n = 9.0; // even numbers create vertical lines, >9 creates a more obvious rosette
    const float df = tot/n; 
    float c = 0.0; // kind of like a threshold for light/dark
    float t = time*1.0; // change the number here to effect speed

    for (float phi =0.0; phi < tot; phi+=df)
    {
        c+=cos(cos(phi)*p.x+sin(phi)*p.y +t);
    }
    //c/=n;
    //c = c>0.5?0.:1.;
    gl_FragColor = vec4(c,c,c,1.0); // might be like R G B A
  
}
