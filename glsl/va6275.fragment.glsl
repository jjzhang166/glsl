// Shader from here: http://www.iquilezles.org/

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;

vec3 getTex(vec2 uv)
{
	return vec3(uv.x, uv.y, sin(time)*sin(time));
}

void main(void)
{
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
    vec2 uv;

    float a = atan(p[1],p[0]);
    float r = sqrt(dot(p,p));
	
    const int max_loop =10;

    uv.x = sin(50.0*cos(r - .25*sin(time)));
    uv.y = sin(a*10.0 + 2.0*cos(time+3.0*r));

    for(int i=0; i<max_loop; i++)
    {
	1+1;    
    }
	
    vec3 col =  (0.35*uv.x+.55*sin(uv.y))*getTex(uv);

    gl_FragColor = vec4(col,1.0);
}