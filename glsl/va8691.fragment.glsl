#ifdef GL_ES
precision mediump float;
#endif

// Taken from http://www.duangle.com/nowhere

uniform float time;
uniform vec2 resolution;

const float axes = 13.0;
const float radius = 10.125;
const float rotate = 0.25;
const float PI = 3.14159;

void main( void )
{
     vec2 p = ( gl_FragCoord.xy / resolution.xy ) / 2.0;
     p -= vec2(0.25,0.25);
   
    float a = atan(p.y,p.x);
    float r = sqrt(dot(p,p)) * radius;
    
    float f = 2.0 * PI / axes;
    
    a /= f;
    a = fract(a);
    if (a > 0.5)
    {
        a = 1.0 - a;
    }
    a *= f;
    a += time * rotate;

    vec3 c = vec3(cos(a+0.39*time), sin(a+time*0.1), cos(a+0.13*time));
    c = fract(c*r)*time*0.2;

    gl_FragColor = vec4(c, 1.0);
}
