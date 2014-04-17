//IQ Version - http://pouet.net/topic.php?which=7931
// las style mod - might be a good alternative in some situations
#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;

float udHexPrism( vec2 p, float h )
{
    vec2 q = abs(p);
    //return max(q.x*0.866025 + q.y*0.5, q.y)-h;
    // can also be expressed as dot prod.
    return max(dot(q, vec2(0.866025, 0.5)), q.y)-h;
}

void main(void)
{
    //vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
    vec2 p = -2.0 + 4.0 * gl_FragCoord.xy / resolution.xy;
    p.x *= 1.3333;

    float d1 = udHexPrism( p, 1.0 );
    float d2 = length(p) - 1.0;

    float f = 0.0; if( d1<0.0 ) f=1.0;
    float g = 0.0; if( d2<0.0 ) g=1.0;
    vec3 col = vec3(f,g,0.0);

    gl_FragColor = vec4(col,1.0);
}