#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;

void main(void)
{
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
    vec2 uv;

    float a = atan(p.y,p.x);
    float r = sqrt(dot(p,p));

    uv.x = cos(20.0*time);
    uv.y = sin(a*15.0 + 10.0*cos(-10.0*time+10.0*r)) ;

    vec3 col =  (.5+(cos(time))*uv.y)*vec3(uv.x, uv.y, 0);
    gl_FragColor = vec4(col,1.0);
}

//Epilectic dead