#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;

void main(void)
{
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;

    float t = time*0.5;
    vec2 offset1 = vec2(0.5*cos(6.0*t),0.5*sin(3.0*t));
    vec2 offset2 = vec2(0.6*sin(3.0*t),0.4*cos(2.0*t));

    float radius1 = sqrt(dot(p-offset1,p-offset1));
    float radius2 = sqrt(dot(p-offset2,p-offset2));
        
    bool toggle1 = mod(radius1,0.2)>0.1;
    bool toggle2 = mod(radius2,0.2)>0.1;

    //xor via if statements
    float col = 0.0;
    if (toggle1) col = 1.0;    
    if (toggle2) col = 1.0;
    if ((toggle1) && (toggle2)) col = 0.0;

    gl_FragColor = vec4(col,col,col,1.0);
}