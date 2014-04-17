#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;

void main(void)
{
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy/(sin(time)+1.5);

    float t = time*0.25;
    vec2 offset1 = vec2(0.8*cos(5.0*t),0.5*sin(3.0*t));
    vec2 offset2 = vec2(0.3*sin(3.0*t),0.4*cos(2.0*t));

    float radius1 = sqrt(dot(p-offset1,p-offset1));
    float radius2 = sqrt(dot(p-offset2,p-offset2));
        
    bool toggle1 = mod(radius1,0.1)>0.05;
    bool toggle2 = mod(radius2,0.1)>0.05;

    //xor via if statements
    float col = 0.0;
    if (toggle1) col = (sin(radius1)+1.0)/2.0;    
    if (toggle2) col = (cos(radius2)+1.0)/2.0;
    if ((toggle1) && (toggle2)) col = 0.0;

    gl_FragColor = vec4(sin(radius1)*cos(radius2)*col,sin(radius1)*col,cos(radius2)*col,1.0);
}