// Shader from here: http://www.iquilezles.org/

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;

vec3 getTex(vec2 uv)
{
	return vec3(uv.x, uv.y, 0.0);
}

void main(void)
{
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
    vec2 uv;

    float a = atan(p.y,p.x);
    float r = sqrt(dot(p,p));

    uv.x = r - .25*time;
    uv.y = sin(a*10.0 + 2.0*cos(time+3.0*r)) ;

    vec3 col =  (.5+.5*uv.y)*getTex(uv);

    gl_FragColor = vec4(col,1.0);
}