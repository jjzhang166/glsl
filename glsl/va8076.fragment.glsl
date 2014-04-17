//IQ Version - http://pouet.net/topic.php?which=7931
#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;

void main(void)
{
    vec2 p = -2.0 + 4.0 * gl_FragCoord.xy / resolution.xy;
    p.x *= 1.3333;
    vec2 q = abs(p);
    float d1 = max(q.x+q.y*0.57735,q.y*1.1547)-1.0;
    float f = 0.0; if( d1<0.0 ) f=1.0;
    gl_FragColor = vec4(f,f,f,1.0);
}